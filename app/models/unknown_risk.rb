class UnknownRisk < ApplicationRecord

  def to_s
    "#{none} | #{low} | #{some} | #{many}"
  end

  def lookup
    [['none',none],['low',low],['some',some],['many',many]]
  end
end
