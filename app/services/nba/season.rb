module Nba
  class Season
    class << self
      def create_season(year)
        Nba::Season.new(year)
      end
    end


    def initialize(year)
      @year = year
      @game_line_type = LineTypeFactory.get_line_type(@year, :game_line)
      game_register = GameRegister.new(ScheduledGame.all, @game_line_type.totals)
      Team.set_register(game_register)
      Team.set_year(year)
    end

    def boxscore(date, team)
      if date
        lines = @game_line_type.boxscore_lines(team, date)
        Nba::Boxscore.new(lines, team)
      else
        nil
      end
    end

    def total_statistics_for_team(team, split_type = :all)
      return TeamTotals.new(Nba::Team.get(team).stats(split_type))
    end

    def opponent_totals
      Nba::DefensiveTotals.new.stats([:all])
    end

    def difference_totals
      Nba::DifferenceTotals.new.stats([:all])
    end
  end
end
