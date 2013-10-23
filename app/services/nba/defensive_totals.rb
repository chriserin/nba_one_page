module Nba
  class DefensiveTotals
    include Stats
    include LineType

    def data
      gtype.opponent_totals
    end
  end
end
