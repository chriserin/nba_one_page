module AggregateInfoHelper
  def abbr_replace(abbr)
    if abbr == "BKN"
      "NJN"
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
