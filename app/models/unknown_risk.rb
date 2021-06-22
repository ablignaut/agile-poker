class UnknownRisk < ApplicationRecord

  def to_s
    "#{none} | #{low} | #{some} | #{many}"
  end
end
