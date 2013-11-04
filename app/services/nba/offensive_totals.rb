module Nba
  class OffensiveTotals
    include Stats
    include LineType

    def data
      gtype.totals
    end
  end
end
