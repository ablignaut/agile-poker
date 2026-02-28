require "test_helper"

class StoryTest < ActiveSupport::TestCase
  setup do
    @game = games(:one)
  end

  test "valid with required fields" do
    story = Story.new(game: @game, issue_key: "PROJ-1", status: "pending", position: 0)
    assert story.valid?
  end

  test "invalid without issue_key" do
    story = Story.new(game: @game, status: "pending", position: 0)
    assert_not story.valid?
    assert_includes story.errors[:issue_key], "can't be blank"
  end

  test "invalid with unrecognised status" do
    story = Story.new(game: @game, issue_key: "PROJ-1", status: "bogus", position: 0)
    assert_not story.valid?
    assert_includes story.errors[:status], "is not included in the list"
  end

  test "pending scope returns only pending stories" do
    assert @game.stories.pending.all? { |s| s.status == "pending" }
  end

  test "active scope returns only active stories" do
    assert @game.stories.active.all? { |s| s.status == "active" }
  end

  test "estimated scope returns only estimated stories" do
    assert @game.stories.estimated.all? { |s| s.status == "estimated" }
  end

  test "ordered scope orders by position then created_at" do
    positions = @game.stories.ordered.map(&:position)
    assert_equal positions.sort, positions
  end
end
