module Nba
  class Standing
    attr_accessor :standings, :wins, :losses, :team_name

    def initialize(team_name, games, standings)
      self.team_name = team_name
      self.wins      = count(games, "W")
      self.losses    = count(games, "L")
      self.standings = standings
    end

    def pct
      wins / (wins + losses) * 1.0
    end
    alias :win_percentage :pct
    alias :win_pct :pct

    def games_back_from_first(division_or_conference)
      games_back_from standings.first_in_category(division_or_conference)
    end
    alias :games_back :games_back_from_first

    def games_back_from(standing)
      games_back  = win_diff(standing) * 0.5 + loss_diff(standing) * 0.5
      (games_back == 0 ? "--" : games_back)
    end

    def division
      TEAMS[team_name][:div]
    end

    def conference
      TEAMS[team_name][:conference]
    end

    def abbr
      TEAMS[team_name][:abbr]
    end

    private
    def count(games, result)
      games.count { |game| game.game_result == result }
    end

    def win_diff(standing)
      standing.wins - wins
    end

    def loss_diff(standing)
      losses - standing.losses
    end
  end
end
