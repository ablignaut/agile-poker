require "test_helper"

class StoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @game   = games(:one)
    @story  = stories(:pending_story)
    @active = stories(:active_story)
  end

  # --- create ---

  test "create adds a story to the game" do
    assert_difference("Story.count", 1) do
      post game_stories_path(@game),
           params: { story: { issue_key: "PROJ-200", description: "" } },
           as: :turbo_stream
    end
    assert_response :success
    assert_equal "PROJ-200", Story.last.issue_key
    assert_equal @game.id, Story.last.game_id
  end

  test "create with blank issue_key does not save" do
    assert_no_difference("Story.count") do
      post game_stories_path(@game),
           params: { story: { issue_key: "" } },
           as: :turbo_stream
    end
  end

  # --- destroy ---

  test "destroy removes the story" do
    assert_difference("Story.count", -1) do
      delete game_story_path(@game, @story), as: :turbo_stream
    end
    assert_response :success
  end

  # --- update ---

  test "update changes the story issue_key" do
    patch game_story_path(@game, @story),
          params: { story: { issue_key: "PROJ-999" } },
          as: :turbo_stream
    assert_response :success
    assert_equal "PROJ-999", @story.reload.issue_key
  end

  # --- accept_estimate ---

  test "accept_estimate marks story as estimated and clears votes" do
    @game.games_players.update_all(complexity: 1, amount_of_work: 1, unknown_risk: 1)

    post accept_estimate_game_story_path(@game, @active), as: :turbo_stream

    assert_response :success
    @active.reload
    assert_equal "estimated", @active.status
    assert_not_nil @active.estimate

    @game.games_players.reload.each do |gp|
      assert_nil gp.complexity
      assert_nil gp.amount_of_work
      assert_nil gp.unknown_risk
    end
  end

  test "accept_estimate auto-advances to the next pending story" do
    post accept_estimate_game_story_path(@game, @active), as: :turbo_stream

    # pending_story (position 0) should now be active
    assert_equal "active", @story.reload.status
  end

  test "accept_estimate with no players voted saves nil estimate" do
    @game.games_players.update_all(complexity: nil, amount_of_work: nil, unknown_risk: nil)

    post accept_estimate_game_story_path(@game, @active), as: :turbo_stream

    assert_response :success
    @active.reload
    assert_equal "estimated", @active.status
    assert_nil @active.estimate
  end

  # --- activate ---

  test "activate sets the story to active" do
    post activate_game_story_path(@game, @story), as: :turbo_stream

    assert_response :success
    assert_equal "active", @story.reload.status
  end

  test "activate deactivates the previously active story" do
    post activate_game_story_path(@game, @story), as: :turbo_stream

    assert_equal 1, @game.stories.reload.active.count
  end

  test "activate clears all votes" do
    @game.games_players.update_all(complexity: 2, amount_of_work: 1, unknown_risk: 1)

    post activate_game_story_path(@game, @story), as: :turbo_stream

    @game.games_players.reload.each do |gp|
      assert_nil gp.complexity
    end
  end
end
