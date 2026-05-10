require "test_helper"

class AmountOfWorkTest < ActiveSupport::TestCase
  test "lookup_with_keys returns label, value and level for each level" do
    record = AmountOfWork.new(tiny: 0.5, little: 1, fair: 3, large: 5, huge: 13)
    triples = record.lookup_with_keys

    assert_equal AmountOfWork::LEVELS.size, triples.size
    assert_equal "tiny (0.5)", triples.first[0]
    assert_equal BigDecimal("0.5"), triples.first[1]
    assert_equal "tiny", triples.first[2]
    assert_equal AmountOfWork::LEVELS, triples.map(&:last)
  end
end
