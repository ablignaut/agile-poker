require "test_helper"

class SizingDefinitionsTest < ActiveSupport::TestCase
  setup { SizingDefinitions.reload! }

  test "exposes all three categories" do
    assert_equal %i[complexity amount_of_work unknown_risk].sort,
                 SizingDefinitions.all.keys.sort
  end

  test "looks up a definition by category and level" do
    description = SizingDefinitions.for(:complexity, :fair)
    assert_kind_of String, description
    assert_match(/some complex logic/i, description)
  end

  test "accepts string keys" do
    assert_equal SizingDefinitions.for(:amount_of_work, :tiny),
                 SizingDefinitions.for("amount_of_work", "tiny")
  end

  test "returns nil for unknown level" do
    assert_nil SizingDefinitions.for(:complexity, :nonexistent)
  end

  test "returns empty hash for unknown category" do
    assert_equal({}, SizingDefinitions.levels(:nonexistent))
  end

  test "every model level has a definition" do
    {
      complexity: Complexity::LEVELS,
      amount_of_work: AmountOfWork::LEVELS,
      unknown_risk: UnknownRisk::LEVELS
    }.each do |category, levels|
      levels.each do |level|
        assert SizingDefinitions.for(category, level).present?,
               "missing definition for #{category}/#{level}"
      end
    end
  end
end
