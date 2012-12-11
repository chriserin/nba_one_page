module NumbersHelper

  def format_percentage(pct)
    if pct == 1
      "1.000"
    else
      ("%.3f" % pct)[1..-1]
    end
  end

  def format_estimate_percentage(pct)
    if pct == 1
      "1.000"
    else
      ("%.2f" % pct)[0..-1]
    end
  end
end
