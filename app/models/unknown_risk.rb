class UnknownRisk < ApplicationRecord

  def to_s
    "none (#{none}) | low (#{low}) | some (#{some}) | many (#{many})"
  end

  def lookup
    [["none (#{none})",none],["low (#{low})",low],["some (#{some})",some],["many (#{many})",many]]
  end
end
