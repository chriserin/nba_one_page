module Nba
  module Schedule
    class Difficulty
      def initialize(win_pct, opp_win_pct, is_home, rest, opponent_rest)
        @result  = 6 * win_pct
        @result += 4 * opp_win_pct
        @result += is_home ? 0 : 1
        @result += rest
        @result -= opponent_rest
      end

      def result
        @result.round(1)
      end

      def to_s
        @result.round(1).to_s
      end
    end
  end
end
