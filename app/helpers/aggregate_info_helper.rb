module AggregateInfoHelper
  def abbr_replace(abbr)
    case abbr
    when "NOH" then "NOR"
    when "BKN" then "NJN"
    else
      abbr
    end
  end

  def brk_abbr_replace(abbr)
    if abbr == "BKN"
      "BRK"
    else
      abbr
    end
  end

  def highlight_difference(value, value_type=:integer)
    formatted_value = format_value(value, value_type)
    if value.to_f >= 0
      diff_class = "positive-difference"
      positive_indicator = "+"
    else
      diff_class = "negative-difference"
      positive_indicator = "-"
    end
    "<span class='#{diff_class}'>#{positive_indicator}#{formatted_value}</span>".html_safe
  end

  def format_value(value, value_type)
    if value_type == :percentage
      result = format_percentage(value.abs)
    elsif value_type == :estimate_percentage
      result = format_estimate_percentage(value.abs)
    else
      result = value.abs
    end
  end
end
