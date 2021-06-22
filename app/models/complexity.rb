class Complexity < ApplicationRecord

  def to_s
    "#{none} | #{little} | #{fair} | #{complex} | #{very_complex}"
  end

  def lookup
    [['none',none],['little',little],['fair',fair],['complex',complex],['very complex',very_complex]]
  end
end
