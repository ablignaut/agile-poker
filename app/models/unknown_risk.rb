class UnknownRisk < ApplicationRecord
  LEVELS = %w[none low some many].freeze

  def to_s
    "none (#{none}) | low (#{low}) | some (#{some}) | many (#{many})"
  end

  def lookup
    [["none (#{none})",none],["low (#{low})",low],["some (#{some})",some],["many (#{many})",many]]
  end

  def lookup_with_keys
    LEVELS.map { |level| [label_for(level), public_send(level), level] }
  end

  private

  def label_for(level)
    "#{level} (#{public_send(level)})"
  end
end
