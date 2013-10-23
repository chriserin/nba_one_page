module Nba
  class Season
    class << self
      def create_season(year)
        Nba::Season.new(year)
      end
    end

    attr_reader :game_register

    def initialize(year)
      @year = year
      @game_line_type = LineTypeFactory.get_line_type(@year, :game_line)
      @game_register = GameRegister.new(ScheduledGame.all, @game_line_type.totals)
      Team.set_register(@game_register)
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

    def standings
      return @standings if @standings
      wins_and_losses = @game_line_type.totals
      @standings = Nba::Standings.new(wins_and_losses)
    end

    def schedule(team, standings)
      results             = standings.find_team(team).games
      scheduled_games     = ScheduledGame.all
      schedule            = Nba::Schedule::Schedule.new scheduled_games, standings, @year
      team_unplayed_games = schedule.unplayed_games_for_team(team)
      Nba::Schedule::TeamSchedule.new results, team_unplayed_games, team, schedule
    end

    def total_statistics_for_team(team, split_type = :all)
      return TeamTotals.new(Nba::Team.get(team).stats(split_type))
    end

    def opponent_totals
      Nba::DefensiveTotals.new.stats([:all])
    end

    def difference_totals
      @difference_totals = @game_line_type.difference_totals.group_by { |line| line.team }.map { |team, lines| lines.inject(:+) }
    end
  end
end
