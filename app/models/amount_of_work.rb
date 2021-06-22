class AmountOfWork < ApplicationRecord

  def to_s
    "#{tiny} | #{little} | #{fair} | #{large} | #{huge}"
  end

  def lookup
    [['tiny',tiny],['little',little],['fair',fair],['large',large],['huge',huge]]
  end
end
