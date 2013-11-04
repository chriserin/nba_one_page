module Nba
  class Season
    class << self
      def create_season(year)
        Nba::Season.new(year)
      end
    end

    def initialize(year)
      @year = year
      @game_line_type = GameLine.make_year_type(@year)
      game_register = GameRegister.new(ScheduledGame(year).all, @game_line_type.totals)
      Team.set_register(game_register)
      Team.set_year(year)
    end

    def boxscore(date, team)
      if date
        lines = @game_line_type.boxscore_lines(team, date)
        Nba::Boxscore.new(lines, team)
      else
        raise "no boxscore"
      end
    end

    def total_statistics_for_team(team, split_type = :all)
      return TeamTotals.new(Nba::Team.get(team).stats(split_type))
    end

    def totals
      Nba::OffensiveTotals.new.stats([:all])
    end

    def opponent_totals
      Nba::DefensiveTotals.new.stats([:all])
    end

    def difference_totals
      Nba::DifferenceTotals.new.stats([:all])
    end
  end
end
