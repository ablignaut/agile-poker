require "test_helper"

class GamesPlayerTest < ActiveSupport::TestCase
  setup do
    @game = games(:one)
  end

  test "voters scope excludes observers" do
    assert @game.games_players.voters.none?(&:observer?)
  end

  test "observers scope returns only observers" do
    assert @game.games_players.observers.all?(&:observer?)
  end

  test "players_all_voted? ignores observers" do
    # Set all voters as voted
    @game.games_players.voters.update_all(complexity: 1, amount_of_work: 1, unknown_risk: 1)
    # Observer has no votes — should still return true
    assert @game.games_players.players_all_voted?
  end

  test "players_all_voted? returns false when a voter has not voted" do
    @game.games_players.update_all(complexity: nil, amount_of_work: nil, unknown_risk: nil)
    assert_not @game.games_players.players_all_voted?
  end

  test "players_all_voted? returns false when there are no voters" do
    @game.games_players.voters.destroy_all
    assert_not @game.games_players.players_all_voted?
  end

  test "observer? returns true for an observer" do
    assert games_players(:observer_one).observer?
  end

  test "observer? returns false for a voter" do
    assert_not games_players(:one).observer?
  end
end
