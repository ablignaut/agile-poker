require "application_system_test_case"

class GamesPlayersTest < ApplicationSystemTestCase
  setup do
    @games_player = games_players(:one)
  end

  test "visiting the index" do
    visit games_players_url
    assert_selector "h1", text: "Games Players"
  end

  test "creating a Games player" do
    visit games_players_url
    click_on "New Games Player"

    fill_in "Amount of work", with: @games_player.amount_of_work
    fill_in "Complexity", with: @games_player.complexity
    fill_in "Game", with: @games_player.game_id
    fill_in "Name", with: @games_player.name
    fill_in "Unknown risk", with: @games_player.unknown_risk
    click_on "Create Games player"

    assert_text "Games player was successfully created"
    click_on "Back"
  end

  test "updating a Games player" do
    visit games_players_url
    click_on "Edit", match: :first

    fill_in "Amount of work", with: @games_player.amount_of_work
    fill_in "Complexity", with: @games_player.complexity
    fill_in "Game", with: @games_player.game_id
    fill_in "Name", with: @games_player.name
    fill_in "Unknown risk", with: @games_player.unknown_risk
    click_on "Update Games player"

    assert_text "Games player was successfully updated"
    click_on "Back"
  end

  test "destroying a Games player" do
    visit games_players_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Games player was successfully destroyed"
  end
end
