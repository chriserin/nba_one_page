module Nba
  class Season
    class << self
      def create_season(year)
        Nba::Season.new(year)
      end
    end

    def initialize(year); end;

    def boxscore(date, team)
      lines = GameLine.boxscore_lines(team, date)
      Nba::Boxscore.new(lines, team)
    end

    def standings
      wins_and_losses = GameLine.win_loss_totals
      Nba::Standings.new(wins_and_losses)
    end

    def schedule(team)
      results        = GameLine.team_results(team)
      unplayed_games = ScheduledGame.unplayed_team_games(team)
      Nba::Schedule.new results, unplayed_games, team
    end

    def total_statistics_for_team(team)
      GameLine.statistic_total_lines(team)
    end
  end
end
