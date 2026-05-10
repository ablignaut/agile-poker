class Complexity < ApplicationRecord
  LEVELS = %w[none little fair complex very_complex].freeze

  def to_s
    "none (#{none}) | little (#{little}) | fair (#{fair}) | complex (#{complex}) | very_complex (#{very_complex})"
  end

  def lookup
    [["none (#{none})",none],["little (#{little})",little],["fair (#{fair})",fair],["complex (#{complex})",complex],["very complex (#{very_complex})",very_complex]]
  end

  def lookup_with_keys
    LEVELS.map { |level| [label_for(level), public_send(level), level] }
  end

  private

  def label_for(level)
    "#{level.tr('_', ' ')} (#{public_send(level)})"
  end
end
