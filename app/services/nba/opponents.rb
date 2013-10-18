module Nba
  module Opponents
    def last_opponents(num=10)
      played_games.reverse.take(num).map {|g| g.opponent }.to_teams
    end

    def next_opponents(num=10)
      unplayed_games.take(num).map {|g| g.opponent }.to_teams
    end
  end
end
