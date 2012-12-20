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
end
