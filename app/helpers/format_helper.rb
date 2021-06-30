# default formatting methods for the site
module FormatHelper

  extend FormatHelper

  def as_average(value, count, options = {})
    return 0 if value.nil? || value == 0 || count.nil? || count == 0
    format_number(value.to_d / count.to_d, options)
  end

  def format_number(number, options = {:precision => 2})
    number ? number_to_currency(number, options.merge({:unit => ''  }).reverse_merge({:strip_insignificant_zeros => true})) : '---'
  end

end
