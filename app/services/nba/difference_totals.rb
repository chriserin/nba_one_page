module Nba
  class DifferenceTotals
    include LineType
    include Stats

    def data
      gtype.difference_totals
    end
  end
end
