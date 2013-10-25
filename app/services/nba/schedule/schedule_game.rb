module Nba
  module Schedule
    class ScheduleGame
      extend Forwardable
      def_delegators :@game_descriptor, :formatted_game_date, :result_description
      def_delegators :@game, :game_date

      attr_accessor :team, :game

      def initialize(game, team_schedule)
        @game, @team_schedule = game, team_schedule
        #@game_descriptor = Nba::GameDescriptor.new @game
        @team = @team_schedule.team
      end

      def game_description
        if game.kind_of? GameModel
          @game.game_text
        else
          @game.game_text_for @team_schedule.team
        end
      end

      def difficulty
        opponent_standing = find_opponent_standing
        Difficulty.new(opponent_standing.win_pct, opponent_standing.opponent_win_pct, is_home, rested_rating, opponent_rested_rating)
      end

      def rested_rating
        rating = 0
        rating += 1 if is_back_to_back?
        rating += 1 if is_four_in_five?
        return rating
      end

      def is_opponent_back_to_back?;  opponent_game.is_back_to_back?  end
      def is_opponent_four_in_five?;  opponent_game.is_four_in_five?  end

      def is_back_to_back?; @team_schedule.calendar.rest_days_before_date(game_date, 1) == 0 end
      def is_four_in_five?; @team_schedule.calendar.rest_days_before_date(game_date, 5) == 1 end

      def is_played?
        game_date.to_date < Date.today
      end

      private
      def opponent_rested_rating
        opponent_game.rested_rating
      end

      def opponent_game
        @team_schedule.find_team_schedule(opponent).find_game(game_date)
      end

      def find_opponent_standing
        @standings.find_team(opponent)
      end

      def opponent
        if @game.class == ScheduledGame
          @game.opponent_of(team)
        else
          @game.opponent
        end
      end

      def is_home?
        if @game.class == ScheduledGame
          @game.home_team == @team
        else
          @game.is_home
        end
      end

      def is_away?
        !is_home?
      end

      def inspect
        "<ScheduleGame #{game_description}>"
      end
    end
  end
end
