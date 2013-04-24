module Nba
  module Schedule
    class AllStarGame
      class << self
        def game_description
          "ALL-STAR GAME IN HOUSTON"
        end

        def game; self; end

        def game_date
          "2013-02-17".to_date
        end

        def is_played?
          game_date.to_date < Date.today
        end

        def is_home?; false; end
        def is_away?; false; end

        def formatted_game_date
          "02/17"
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
end
