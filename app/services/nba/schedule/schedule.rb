module Nba
  module Schedule
    class Schedule
      def initialize(games, standings)
        @team_schedules = {}
        Nba::TEAMS.keys.each do |team|
          team_games            = games.select {|game| game.home_team == team or game.away_team == team}
          results               = standings.games_for_team(team)
          @team_schedules[team] = TeamSchedule.new results, team_games, team, standings, self
        end
      end

      def find_team_schedule(team)
        @team_schedules[team]
      end

      def unplayed_games_for_team(team)
        @team_schedules[team].filter_games_by_today
      end
    end
  end
end
