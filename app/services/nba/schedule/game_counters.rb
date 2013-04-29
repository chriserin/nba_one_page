module Nba
  module Schedule
    module GameCounters
      def back_to_back_count
        games.count {|game| game.is_back_to_back?}
      end

      def four_in_five_count
        games.count {|game| game.is_four_in_five?}
      end

      def opponent_back_to_back_count
        games.count {|game| game.is_opponent_back_to_back?}
      end

      def opponent_four_in_five_count
        games.count {|game| game.is_opponent_four_in_five?}
      end

      def home_games_left; games_left {|game| game.is_home? } end
      def away_games_left; games_left {|game| ! game.is_home? } end

      def easy_games_left;                  games_left {|game| game.difficulty < 5}                          end
      def medium_games_left;                games_left {|game| game.difficulty < 7 and game.difficulty >= 5} end
      def hard_games_left;                  games_left {|game| game.difficulty >= 7}                         end
      def back_to_back_count_left;          games_left {|game| game.is_back_to_back? }                       end
      def opponent_back_to_back_count_left; games_left {|game| game.is_opponent_back_to_back? }              end

      def games_left &block
        games_today_and_after.count block
      end
    end
  end
end
