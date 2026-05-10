require "test_helper"

class JiraCommentRendererTest < ActiveSupport::TestCase
  Player = Struct.new(:name, :complexity, :amount_of_work, :unknown_risk, keyword_init: true) do
    def total_points
      [complexity, amount_of_work, unknown_risk].compact.sum
    end

    def fibonacci_vote
      [1, 2, 3, 5, 8, 13, 20].find { |v| v >= total_points }
    end
  end

  class FakeVoters
    include Enumerable

    def initialize(players)
      @players = players
    end

    def each(&block) = @players.each(&block)
    def players_voted = @players.reject { |p| [p.complexity, p.amount_of_work, p.unknown_risk].all?(&:nil?) }
    def sum(attr) = players_voted.sum { |p| p.public_send(attr) || 0 }
    def sum_total_points = players_voted.sum(&:total_points)
    def sum_fibonacci_vote = players_voted.sum(&:fibonacci_vote)
    def highest_voter = players_voted.max_by(&:total_points)
    def lowest_voter  = players_voted.min_by(&:total_points)
  end

  class FakeGame
    def initialize(voters)
      @voters = voters
    end

    def games_players
      Struct.new(:voters).new(@voters)
    end
  end

  test "renders the player and summary tables in wiki markup" do
    voters = FakeVoters.new([
      Player.new(name: "Alice", complexity: 3, amount_of_work: 2, unknown_risk: 1),
      Player.new(name: "Bob",   complexity: 1, amount_of_work: 1, unknown_risk: 1)
    ])
    body = JiraCommentRenderer.render(FakeGame.new(voters))

    assert_includes body, "||Player||Complexity||Amount of Work||Unknowns/Risks||Total||Fibonacci||"
    assert_includes body, "|Alice|3|2|1|6|8|"
    assert_includes body, "|Bob|1|1|1|3|3|"
    assert_includes body, "|Average|"
    assert_includes body, "||Metric||Player||Total||Fibonacci||"
    assert_includes body, "|Highest|Alice|"
    assert_includes body, "|Lowest|Bob|"
  end

  test "escapes pipe characters in names so they don't break the wiki table" do
    voters = FakeVoters.new([
      Player.new(name: "Pat|Pipe", complexity: 1, amount_of_work: 1, unknown_risk: 1)
    ])
    body = JiraCommentRenderer.render(FakeGame.new(voters))
    assert_includes body, "Pat\\|Pipe"
  end

  test "shows a placeholder summary when nobody has voted" do
    voters = FakeVoters.new([
      Player.new(name: "Alice", complexity: nil, amount_of_work: nil, unknown_risk: nil)
    ])
    body = JiraCommentRenderer.render(FakeGame.new(voters))
    assert_includes body, "_No votes recorded._"
  end
end
