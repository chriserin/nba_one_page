module Nba
  module PlayedWhereCounts
    def home_games_remaining
      unplayed_games.count do |game|
        game.is_home?
      end
    end

    def away_games_remaining
      unplayed_games.count - home_games_remaining
    end
  end
end
