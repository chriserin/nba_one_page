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

    def standings
      wins_and_losses = GameLine.season(@year).win_loss_totals
      Nba::Standings.new(wins_and_losses)
    end

    def schedule(team)
      results        = GameLine.season(@year).team_results(team)
      unplayed_games = ScheduledGame.unplayed_team_games(team)
      Nba::Schedule.new results, unplayed_games, team
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
