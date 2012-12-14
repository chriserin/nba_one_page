module Nba
  class Standing
    attr_accessor :standings, :wins, :losses, :team_name, :games, :games_total, :opponents

    def initialize(team_name, games, standings)
      @team_name = team_name
      @wins      = count(games, "W")
      @losses    = count(games, "L")
      @standings = standings
      @games_total = games.inject(:+)
      @opponents = collect_opponents(games)
      @games = games
    end

    def pct
      wins / ((wins + losses) * 1.0)
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

    def collect_opponents(games)
      games.map {|g| g.opponent}
    end

    def opponents_combined_record
      return @opponent_wins, @opponent_losses if @opponent_wins
      records = opponent_records
      @opponent_wins, @opponent_losses = opponent_wins(records), opponent_losses(records)
    end

    def opponent_records
      @opponents.map {|opponent| standings.find {|s| s.team_name == opponent} }
    end

    def opponent_wins(records)
      records.map {|record| record.wins }.inject(:+)
    end

    def opponent_losses(records)
      records.map {|record| record.losses }.inject(:+)
    end

    def opponent_win_pct
      o_wins, o_losses = opponents_combined_record
      o_wins / ((o_wins + o_losses) * 1.0)
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

    def pace
      @games_total.pace
    end

    def offensive_rating
      @games_total.offensive_rating.round 2
    end

    def defensive_rating
      @games_total.defensive_rating.round 2
    end

    def rating_difference
      (@games_total.offensive_rating - @games_total.defensive_rating).round 2
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
