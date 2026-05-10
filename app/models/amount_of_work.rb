class AmountOfWork < ApplicationRecord
  LEVELS = %w[tiny little fair large huge].freeze

  def to_s
    "tiny (#{tiny}) | little (#{little}) | fair (#{fair}) | large (#{large}) | huge (#{huge})"
  end

  def lookup
    [["tiny (#{tiny})",tiny],["little (#{little})",little],["fair (#{fair})",fair],["large (#{large})",large],["huge (#{huge})",huge]]
  end

  def lookup_with_keys
    LEVELS.map { |level| [label_for(level), public_send(level), level] }
  end

  private

  def label_for(level)
    "#{level} (#{public_send(level)})"
  end
end
