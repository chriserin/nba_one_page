module Nba
  module Schedule
    class Schedule
      attr_accessor :year

      def initialize(games, standings, year)
        @year = year
        @team_schedules = {}
        Nba::TEAMS.keys.each do |team|
          team_games            = games.select {|game| game.home_team == team or game.away_team == team}
          results               = standings.games_for_team(team)
          @team_schedules[team] = TeamSchedule.new results, team_games, team, self
        end
      end

      def find_team_schedule(team)
        @team_schedules[team]
      end

      def unplayed_games_for_team(team)
        @team_schedules[team].games_today_and_after
      end
    end
  end
end
