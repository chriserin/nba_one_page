module Nba
  module Schedule
    class AllStarGame
      def initialize(date)
        @date = date
      end

      def game_description
        "ALL-STAR GAME"
      end

      def game; self end

      def game_date
        @date.to_date
      end

      def is_played?
        game_date.to_date < Date.today
      end

      def is_home?; false; end
      def is_away?; false; end

      def formatted_game_date
        "02/17"
      end

      def game_result
        ""
      end

      def result_description
        ""
      end

      def is_opponent_back_to_back?
        false
      end

      def is_opponent_four_in_five?
        false
      end

      def is_back_to_back?
        false
      end

      def is_four_in_five?
        false
      end

      def difficulty
        ""
      end
    end
  end
end
