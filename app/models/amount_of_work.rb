class AmountOfWork < ApplicationRecord

  def to_s
    "tiny (#{tiny}) | little (#{little}) | fair (#{fair}) | large (#{large}) | huge (#{huge})"
  end

  def lookup
    [["tiny (#{tiny})",tiny],["little (#{little})",little],["fair (#{fair})",fair],["large (#{large})",large],["huge (#{huge})",huge]]
  end
end
