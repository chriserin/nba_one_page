module Nba
  class Season
    class << self
      def create_season(year)
        Nba::Season.new(year)
      end
    end

    def initialize(year)
      @year = year 
    end

    def boxscore(date, team)
      if date
        lines = GameLine.season(@year).boxscore_lines(team, date)
        Nba::Boxscore.new(lines, team)
      else
        nil
      end
    end

    def all_yesterdays_boxscores(date)
      lines = GameLine.season(@year).game_lines(date || Date.yesterday).boxscore_sort
      grouped_lines = lines.group_by {|line| [line.team, line.opponent].sort.join }
      grouped_lines.values.map {|lines| Nba::Boxscore.new(lines, lines.find{ |line| ! line.is_home}.team)}
    end

    def standings
      return @standings if @standings
      wins_and_losses = GameLine.season(@year).win_loss_totals
      @standings = Nba::Standings.new(wins_and_losses)
    end

    def schedule(team, standings)
      results        = standings.find_team(team).games
      scheduled_games = ScheduledGame.all
      schedule = Nba::Schedule.new scheduled_games, standings
      team_unplayed_games = schedule.unplayed_games_for_team(team)
      Nba::TeamSchedule.new results, team_unplayed_games, team, standings, schedule
    end

    def total_statistics_for_team(team)
      lines = GameLine.season(@year).statistic_total_lines(team)
      Nba::TeamTotals.new lines
    end

    def total_statistics_for_former_players(team)
      Nba::TeamTotals.new GameLine.season(@year).statistic_total_lines_former_players(team)
    end
  end
end
