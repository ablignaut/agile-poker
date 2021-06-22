class AmountOfWork < ApplicationRecord

  def to_s
    "#{tiny} | #{little} | #{fair} | #{large} | #{huge}"
  end
end
