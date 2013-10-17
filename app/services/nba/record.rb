module Nba
  module Record
    def wins
      games.count {|g| g.played? and g.result == "W"}
    end

    def losses
      games.count {|g| g.played? and g.result == "L"}
    end

    def pct
      wins / ((wins + losses) * 1.0)
    end
  end
end
