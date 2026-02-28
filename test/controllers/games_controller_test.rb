require "test_helper"

class GamesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @game = games(:one)
  end

  test "should get index" do
    get games_url
    assert_response :success
  end

  test "should get new" do
    get new_game_url
    assert_response :success
  end

  test "should create game" do
    assert_difference('Game.count') do
      post games_url, params: { game: { amount_of_work_id: @game.amount_of_work_id, complexity_id: @game.complexity_id, name: @game.name, unknown_risk_id: @game.unknown_risk_id } }
    end

    assert_redirected_to game_url(Game.last)
  end

  test "should show game" do
    get game_url(@game)
    assert_response :success
  end

  test "should get edit" do
    get edit_game_url(@game)
    assert_response :success
  end

  test "should update game" do
    patch game_url(@game), params: { game: { amount_of_work_id: @game.amount_of_work_id, complexity_id: @game.complexity_id, name: @game.name, unknown_risk_id: @game.unknown_risk_id } }
    assert_redirected_to game_url(@game)
  end

  test "should destroy game" do
    assert_difference('Game.count', -1) do
      delete game_url(@game)
    end

    assert_redirected_to games_url
  end

  # --- observer mode ---

  test "join as observer stores observer flag" do
    post join_game_path(@game), params: { games_player: { name: "Observer Dave", observer: "1" } }
    player = @game.games_players.find_by(name: "Observer Dave")
    assert player.observer?
  end

  test "join as voter stores observer false" do
    post join_game_path(@game), params: { games_player: { name: "Voter Eve", observer: "0" } }
    player = @game.games_players.find_by(name: "Voter Eve")
    assert_not player.observer?
  end

  test "observer cannot vote" do
    observer = games_players(:observer_one)
    post player_vote_game_path(@game), params: { games_player: { name: observer.name, complexity: 1, amount_of_work: 1, unknown_risk: 1 } }
    assert_response :forbidden
  end
end
