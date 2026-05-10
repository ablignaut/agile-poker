require "test_helper"
require "ostruct"

class JiraClientTest < ActiveSupport::TestCase
  ENV_KEYS = %w[JIRA_API_URL JIRA_URL JIRA_EMAIL JIRA_API_TOKEN].freeze

  setup do
    @saved_env = ENV_KEYS.to_h { |k| [k, ENV[k]] }
    ENV["JIRA_API_URL"]   = "https://example.atlassian.net"
    ENV["JIRA_EMAIL"]     = "user@example.com"
    ENV["JIRA_API_TOKEN"] = "token-123"
    @saved_cache = Rails.cache
    Rails.cache = ActiveSupport::Cache::MemoryStore.new
  end

  teardown do
    @saved_env.each { |k, v| ENV[k] = v }
    Rails.cache = @saved_cache
  end

  test "configured? is true when api url, email and token are present" do
    assert JiraClient.configured?
  end

  test "configured? is false when any required env var is missing" do
    ENV["JIRA_EMAIL"] = nil
    refute JiraClient.configured?
  end

  test "issue returns empty result when not configured" do
    ENV["JIRA_API_TOKEN"] = nil
    result = JiraClient.issue("ABC-1")
    refute result.found?
  end

  test "issue parses summary and detects custom field presence by name" do
    body = {
      "names" => {
        "summary" => "Summary",
        "customfield_10016" => "Story Points",
        "customfield_10100" => "Acceptance Criteria",
        "customfield_10101" => "Technical Review",
        "customfield_10102" => "QA Review"
      },
      "fields" => {
        "summary" => "Build the thing",
        "customfield_10016" => 3.0,
        "customfield_10100" => "Given/When/Then…",
        "customfield_10101" => nil,
        "customfield_10102" => ""
      }
    }.to_json

    stub_http_response(Net::HTTPSuccess, body: body) do
      result = JiraClient.issue("ABC-1")
      assert result.found?
      assert_equal "Build the thing", result.summary
      assert result.acceptance_criteria_present
      refute result.technical_review_present
      refute result.qa_review_present
      assert_equal "customfield_10016", result.story_points_field_id
    end
  end

  test "issue discovers the story points field under the new 'Story point estimate' name" do
    body = {
      "names" => { "customfield_10020" => "Story point estimate" },
      "fields" => { "customfield_10020" => nil }
    }.to_json

    stub_http_response(Net::HTTPSuccess, body: body) do
      assert_equal "customfield_10020", JiraClient.issue("ABC-1").story_points_field_id
    end
  end

  test "issue caches results across calls" do
    body = { "names" => {}, "fields" => { "summary" => "Cached" } }.to_json
    call_count = 0
    stub_http_response(Net::HTTPSuccess, body: body) do
      JiraClient.issue("ABC-1")
      call_count = $jira_stub_call_count
      JiraClient.issue("ABC-1")
    end
    # The stub increments call count once; second call comes from cache.
    assert_equal 1, $jira_stub_call_count
  end

  test "refresh_issue invalidates the cache and re-fetches" do
    body = { "names" => {}, "fields" => { "summary" => "First" } }.to_json
    stub_http_response(Net::HTTPSuccess, body: body) do
      JiraClient.issue("ABC-1")
      JiraClient.refresh_issue("ABC-1")
      assert_equal 2, $jira_stub_call_count
    end
  end

  test "issue returns empty result on non-success response" do
    stub_http_response(Net::HTTPNotFound, body: "") do
      refute JiraClient.issue("ABC-1").found?
    end
  end

  test "add_comment posts to the v2 comment endpoint with a JSON body" do
    captured = nil
    stub_http_response(Net::HTTPSuccess, body: "{}", capture: ->(req) { captured = req }) do
      JiraClient.add_comment("ABC-1", "hello")
    end
    assert_equal "POST", captured.method
    assert_match %r{/rest/api/2/issue/ABC-1/comment}, captured.path
    assert_equal "application/json", captured["Content-Type"]
    assert_equal({ "body" => "hello" }, JSON.parse(captured.body))
  end

  test "add_comment is a no-op when not configured" do
    ENV["JIRA_API_TOKEN"] = nil
    # No stub set — would raise if the method tried to make a request.
    assert_nil JiraClient.add_comment("ABC-1", "hello")
  end

  test "update_story_points PUTs the discovered field with a numeric value" do
    Rails.cache.write("jira:issue:ABC-1", JiraClient::Result.new(found: true, story_points_field_id: "customfield_10016"))
    captured = nil
    stub_http_response(Net::HTTPSuccess, body: "{}", capture: ->(req) { captured = req }) do
      JiraClient.update_story_points("ABC-1", 5)
    end
    assert_equal "PUT", captured.method
    assert_match %r{/rest/api/3/issue/ABC-1$}, captured.path
    assert_equal "application/json", captured["Content-Type"]
    assert_equal({ "fields" => { "customfield_10016" => 5.0 } }, JSON.parse(captured.body))
  end

  test "update_story_points is a no-op when the story points field cannot be discovered" do
    Rails.cache.write("jira:issue:ABC-1", JiraClient::Result.new(found: true, story_points_field_id: nil))
    # No stub set — would raise if a request fired.
    assert_nil JiraClient.update_story_points("ABC-1", 5)
  end

  test "update_story_points is a no-op when not configured" do
    ENV["JIRA_API_TOKEN"] = nil
    assert_nil JiraClient.update_story_points("ABC-1", 5)
  end

  private

  # Replaces Net::HTTP#request with a stub for the duration of the block.
  # Tracks call count in $jira_stub_call_count so tests can assert it.
  def stub_http_response(status_class, body:, capture: nil)
    $jira_stub_call_count = 0
    fake_response = status_class.new("1.1", status_code_for(status_class), "stub")
    fake_response.instance_variable_set(:@body, body)
    def fake_response.body; @body; end

    Net::HTTP.class_eval do
      alias_method :__orig_request, :request
      define_method(:request) do |req, *args|
        $jira_stub_call_count += 1
        capture.call(req) if capture
        fake_response
      end
    end

    yield
  ensure
    Net::HTTP.class_eval do
      alias_method :request, :__orig_request
      remove_method :__orig_request
    end
  end

  def status_code_for(klass)
    case klass.name
    when "Net::HTTPSuccess"  then "200"
    when "Net::HTTPNotFound" then "404"
    else "500"
    end
  end
end
