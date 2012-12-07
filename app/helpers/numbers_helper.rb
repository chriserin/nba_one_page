module NumbersHelper

  def format_percentage(pct)
    if pct == 1
      "1.000"
    else
      ("%.3f" % pct)[1..-1]
    end
  end
end
