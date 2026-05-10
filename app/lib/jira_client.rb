require "net/http"
require "json"
require "uri"

module JiraClient
  Result = Struct.new(
    :summary,
    :acceptance_criteria_present,
    :technical_review_present,
    :qa_review_present,
    :story_points_field_id,
    :found,
    keyword_init: true
  ) do
    def self.empty
      new(found: false)
    end

    def found?
      found ? true : false
    end
  end

  FIELD_LABELS = {
    acceptance_criteria_present: "acceptance criteria",
    technical_review_present:    "technical review",
    qa_review_present:           "qa review"
  }.freeze

  # Jira Cloud uses "Story Points"; newer instances/teams use "Story point estimate".
  STORY_POINTS_FIELD_NAMES = ["story points", "story point estimate"].freeze

  class << self
    def configured?
      api_url.present? && email.present? && token.present?
    end

    def issue(issue_key)
      return Result.empty unless configured? && issue_key.present?
      Rails.cache.fetch(cache_key(issue_key)) { fetch_issue(issue_key) }
    end

    def refresh_issue(issue_key)
      return Result.empty unless configured? && issue_key.present?
      Rails.cache.delete(cache_key(issue_key))
      issue(issue_key)
    end

    def add_comment(issue_key, body)
      return unless configured? && issue_key.present? && body.present?
      payload = { body: body }.to_json
      response = perform_request(:post, "/rest/api/2/issue/#{issue_key}/comment", body: payload, content_type: "application/json")
      unless response.is_a?(Net::HTTPSuccess)
        Rails.logger.warn("JiraClient.add_comment got #{response.code} for #{issue_key}: #{response.body}")
      end
      response
    rescue => e
      Rails.logger.warn("JiraClient.add_comment failed for #{issue_key}: #{e.class}: #{e.message}")
      nil
    end

    def update_story_points(issue_key, points)
      return unless configured? && issue_key.present? && points.present?

      field_id = issue(issue_key).story_points_field_id
      unless field_id
        Rails.logger.warn("JiraClient.update_story_points: no Story Points field discovered for #{issue_key}")
        return
      end

      payload = { fields: { field_id => points.to_f } }.to_json
      response = perform_request(:put, "/rest/api/3/issue/#{issue_key}", body: payload, content_type: "application/json")
      unless response.is_a?(Net::HTTPSuccess)
        Rails.logger.warn("JiraClient.update_story_points got #{response.code} for #{issue_key}: #{response.body}")
      end
      response
    rescue => e
      Rails.logger.warn("JiraClient.update_story_points failed for #{issue_key}: #{e.class}: #{e.message}")
      nil
    end

    private

    def fetch_issue(issue_key)
      response = perform_request(:get, "/rest/api/3/issue/#{issue_key}?expand=names&fields=*all")
      return Result.empty unless response.is_a?(Net::HTTPSuccess)

      json = JSON.parse(response.body)
      names  = json["names"] || {}
      fields = json["fields"] || {}

      Result.new(
        found: true,
        summary: fields["summary"],
        acceptance_criteria_present: field_present_by_name?(names, fields, FIELD_LABELS[:acceptance_criteria_present]),
        technical_review_present:    field_present_by_name?(names, fields, FIELD_LABELS[:technical_review_present]),
        qa_review_present:           field_present_by_name?(names, fields, FIELD_LABELS[:qa_review_present]),
        story_points_field_id:       find_field_id_by_names(names, STORY_POINTS_FIELD_NAMES)
      )
    rescue => e
      Rails.logger.warn("JiraClient.fetch_issue failed for #{issue_key}: #{e.class}: #{e.message}")
      Result.empty
    end

    def field_present_by_name?(names, fields, label)
      id = find_field_id_by_names(names, [label])
      return false unless id
      !blank_value?(fields[id])
    end

    def find_field_id_by_names(names, candidates)
      targets = candidates.map { |c| c.to_s.downcase }
      id, _ = names.find { |_, n| targets.include?(n.to_s.downcase) }
      id
    end

    def blank_value?(value)
      return true if value.nil?
      return true if value.respond_to?(:empty?) && value.empty?
      false
    end

    def perform_request(method, path, body: nil, content_type: nil)
      uri = URI.join(ensure_trailing_slash(api_url), path.sub(%r{^/}, ""))
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = (uri.scheme == "https")
      http.open_timeout = 5
      http.read_timeout = 10

      request_class = case method
                      when :get  then Net::HTTP::Get
                      when :put  then Net::HTTP::Put
                      when :post then Net::HTTP::Post
                      else raise ArgumentError, "unsupported method #{method.inspect}"
                      end
      request = request_class.new(uri.request_uri)
      request.basic_auth(email, token)
      request["Accept"] = "application/json"
      request["Content-Type"] = content_type if content_type
      request.body = body if body

      http.request(request)
    end

    def ensure_trailing_slash(url)
      url.end_with?("/") ? url : "#{url}/"
    end

    def cache_key(issue_key)
      "jira:issue:#{issue_key}"
    end

    def api_url
      ENV["JIRA_API_URL"].presence || ENV["JIRA_URL"].presence
    end

    def email
      ENV["JIRA_EMAIL"].presence
    end

    def token
      ENV["JIRA_API_TOKEN"].presence
    end
  end
end
