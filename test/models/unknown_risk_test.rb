require "test_helper"

class UnknownRiskTest < ActiveSupport::TestCase
  test "lookup_with_keys returns label, value and level for each level" do
    record = UnknownRisk.new(none: 0, low: 1, some: 2, many: 5)
    triples = record.lookup_with_keys

    assert_equal UnknownRisk::LEVELS.size, triples.size
    assert_equal "none (0.0)", triples.first[0]
    assert_equal BigDecimal("0"), triples.first[1]
    assert_equal "none", triples.first[2]
    assert_equal UnknownRisk::LEVELS, triples.map(&:last)
  end
end
