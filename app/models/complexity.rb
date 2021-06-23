class Complexity < ApplicationRecord

  def to_s
    "none (#{none}) | little (#{little}) | fair (#{fair}) | complex (#{complex}) | very_complex (#{very_complex})"
  end

  def lookup
    [["none (#{none})",none],["little (#{little})",little],["fair (#{fair})",fair],["complex (#{complex})",complex],["very complex (#{very_complex})",very_complex]]
  end
end
