require "test_helper"

class GamesPlayersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @games_player = games_players(:one)
  end

  test "should get index" do
    get games_players_url
    assert_response :success
  end

  test "should get new" do
    get new_games_player_url
    assert_response :success
  end

  test "should create games_player" do
    assert_difference('GamesPlayer.count') do
      post games_players_url, params: { games_player: { amount_of_work: @games_player.amount_of_work, complexity: @games_player.complexity, game_id: @games_player.game_id, name: @games_player.name, unknown_risk: @games_player.unknown_risk } }
    end

    assert_redirected_to games_player_url(GamesPlayer.last)
  end

  test "should show games_player" do
    get games_player_url(@games_player)
    assert_response :success
  end

  test "should get edit" do
    get edit_games_player_url(@games_player)
    assert_response :success
  end

  test "should update games_player" do
    patch games_player_url(@games_player), params: { games_player: { amount_of_work: @games_player.amount_of_work, complexity: @games_player.complexity, game_id: @games_player.game_id, name: @games_player.name, unknown_risk: @games_player.unknown_risk } }
    assert_redirected_to games_player_url(@games_player)
  end

  test "should destroy games_player" do
    assert_difference('GamesPlayer.count', -1) do
      delete games_player_url(@games_player)
    end

    assert_redirected_to games_players_url
  end
end
