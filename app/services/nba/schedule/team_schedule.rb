module Nba
  module Schedule
    class TeamSchedule
      attr_accessor :played_games, :unplayed_games, :team

      def initialize(played_games, unplayed_games, team, standings, schedule)
        @played_games, @unplayed_games, @team, @schedule = played_games, unplayed_games, team, schedule

        @played_games.sort_by! { |g| g.game_date.to_date }

        @wrapped_played_games = []
        @wrapped_unplayed_games = []
        (@played_games + @unplayed_games).sort_by {|g| g.game_date.to_date }.each do |game|
          previous_schedule_game = games.last

          if game.kind_of? GameModel
            @wrapped_played_games.push ScheduleGame.new(team, game, previous_schedule_game, standings, schedule)
          else
            @wrapped_unplayed_games.push ScheduleGame.new(team, game, previous_schedule_game, standings, schedule)
          end
        end
      end

      def display_games
        @wrapped_played_games.reverse + (@wrapped_unplayed_games + [AllStarGame]).sort_by{ |g| g.game_date.to_date }
      end

      def display_games_range(start, finish)
        display_games[start..finish] || []
      end

      def games
        @wrapped_played_games + @wrapped_unplayed_games
      end

      def find_game(game_date)
        games.find {|game| game.game_date.to_date == game_date.to_date }
      end

      def filter_games_by_today
        @unplayed_games.select {|game| game.game_date.to_date >= Date.today}
      end

      def filter_wrapped_games_by_today
        @wrapped_unplayed_games.select {|game| game.game_date.to_date >= Date.today}
      end

      def back_to_back_count
        games.count {|game| game.is_back_to_back?}
      end

      def four_in_five_count
        games.count {|game| game.is_four_in_five?}
      end

      def opponent_back_to_back_count
        games.count {|game| game.is_opponent_back_to_back?}
      end

      def opponent_four_in_five_count
        games.count {|game| game.is_opponent_four_in_five?}
      end

      def back_to_back_count_left
        filter_wrapped_games_by_today.count {|game| game.is_back_to_back? }
      end

      def opponent_back_to_back_count_left
        filter_wrapped_games_by_today.count {|game| game.is_opponent_back_to_back? }
      end

      def home_games_left
        filter_games_by_today.count {|game| game.home_team == @team }
      end

      def away_games_left
        filter_games_by_today.count {|game| game.away_team == @team }
      end

      def easy_games_left
        filter_wrapped_games_by_today.count {|game| game.difficulty < 5}
      end

      def medium_games_left
        filter_wrapped_games_by_today.count {|game| game.difficulty < 7 and game.difficulty >= 5}
      end

      def hard_games_left
        filter_wrapped_games_by_today.count {|game| game.difficulty >= 7}
      end

      def avg_difficulty_left
        avg_games = filter_wrapped_games_by_today
        return (avg_games.map{|game| game.difficulty }.inject(:+) / avg_games.count.to_f).round(1) if avg_games.count > 0
        return "--"
      end
    end
  end
end
