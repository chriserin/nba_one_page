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
    end

    def boxscore(date, team)
      if date
        lines = @game_line_type.boxscore_lines(team, date)
        Nba::Boxscore.new(lines, team)
      else
        nil
      end
    end

    def all_yesterdays_boxscores(date)
      lines = @game_line_type.game_lines(date || Date.yesterday).boxscore_sort
      grouped_lines = lines.group_by {|line| [line.team, line.opponent].sort.join }
      grouped_lines.values.map {|lines| Nba::Boxscore.new(lines, lines.find{ |line| ! line.is_home}.team)}
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

    def total_statistics_for_team(team)
      lines = @game_line_type.statistic_total_lines(team)
      Nba::TeamTotals.new lines
    end

    def total_statistics_for_former_players(team)
      Nba::TeamTotals.new @game_line_type.statistic_total_lines_former_players(team)
    end

    def opponent_totals
      @opponent_totals = @game_line_type.opponent_totals.group_by { |line| line.team }.map { |team, lines| lines.inject(:+) }
    end

    def difference_totals
      @difference_totals = @game_line_type.difference_totals.group_by { |line| line.team }.map { |team, lines| lines.inject(:+) }
    end
  end
end
