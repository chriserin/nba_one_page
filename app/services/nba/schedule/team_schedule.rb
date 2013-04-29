module Nba
  module Schedule
    class TeamSchedule
      include Nba::Schedule::GameCounters
      include Nba::OpponentRecords

      attr_accessor :played_games, :scheduled_games, :team, :calendar, :wins, :losses

      def initialize(played_games, scheduled_games, team, schedule)
        @team     = team
        @schedule = schedule
        @wins     = played_games.count {|game| game.game_result == "W"}
        @losses   = played_games.count - @wins

        @calendar = Calendar.new(@schedule.year)
        @calendar.add_games(scheduled_games) {|game| ScheduleGame.new(game, self)}
        @calendar.add_games(played_games)    {|game| ScheduleGame.new(game, self)}
        collect_opponents(played_games)
      end

      def games
        @calendar.games
      end

      def display_games_range(start, finish)
        games[start..finish] || []
      end

      def last_game_played
        games.select { |game| game.is_played? }.last.game_date
      end

      def find_game(game_date)
        games.find {|game| game.game_date.to_date == game_date.to_date }
      end

      def find_team_schedule(other_team)
        @schedule.find_team_schedule(other_team)
      end

      def games_today_and_after
        games.select {|game| game.game_date.to_date >= Date.today}
      end

      def avg_difficulty_left
        avg_games = games_today_and_after
        return (avg_games.map{|game| game.difficulty }.inject(:+) / avg_games.count.to_f).round(1) if avg_games.count > 0
        return "--"
      end

      private

      #works with OpponentRecords module
      def opponent_records
        @opponents.map { |opponent| find_team_schedule(opponent) }
      end
    end
  end
end
