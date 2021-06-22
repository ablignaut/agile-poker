class Complexity < ApplicationRecord

  def to_s
    "#{none} | #{little} | #{fair} | #{complex} | #{very_complex}"
  end
end
