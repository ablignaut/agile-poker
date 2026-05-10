require "test_helper"

class ComplexityTest < ActiveSupport::TestCase
  test "lookup_with_keys returns label, value and level for each level" do
    record = Complexity.new(none: 1, little: 2, fair: 3, complex: 5, very_complex: 8)
    triples = record.lookup_with_keys

    assert_equal Complexity::LEVELS.size, triples.size
    assert_equal "none (1.0)", triples.first[0]
    assert_equal BigDecimal("1"), triples.first[1]
    assert_equal "none", triples.first[2]
    assert_equal "very complex", triples.last[0].split(" (").first
    assert_equal Complexity::LEVELS, triples.map(&:last)
  end
end
