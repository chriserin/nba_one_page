module Nba
  module Schedule
    class ScheduleGame
      attr_accessor :team, :game, :previous_schedule_game

      def initialize(team, game, previous_schedule_game, standings, schedule)
        @team, @game, @previous_schedule_game, @standings, @schedule = team, game, previous_schedule_game, standings, schedule
      end

      def game_description
        if game.kind_of? GameModel
          @game.game_text
        else
          @game.game_text_for team
        end
      end

      def result_description
        "#{@game.game_result}#{difference_indicator}#{@game.plus_minus.abs}"
      end

      def difference_indicator
        @game.game_result == "W" ? "+" : "-"
      end

      def difficulty
        standing = find_opponent_standing
        result = (6 * standing.win_pct) + (4 * standing.opponent_win_pct) + (is_home? ? 0 : 1) + rested_rating - opponent_rested_rating
        result.round(1)
      end

      def rested_rating
        rating = 0
        rating += 1 if is_back_to_back?
        rating += 1 if is_four_in_five?
        return rating
      end

      def opponent_rested_rating
        opponent_game.rested_rating
      end

      def is_opponent_back_to_back?
        opponent_game.is_back_to_back?
      end

      def is_opponent_four_in_five?
        opponent_game.is_four_in_five?
      end

      def opponent_game
        @schedule.find_team_schedule(opponent).find_game(game_date)
      end

      def is_back_to_back?
        @previous_schedule_game and @previous_schedule_game.game_date.to_date == @game.game_date.to_date - 1
      end

      def game_date
        @game.game_date
      end

      def is_played?
        game_date.to_date < Date.today
      end

      def formatted_game_date
        game_date.to_date.strftime("%m/%d")
      end

      def is_four_in_five?
        third_previous_schedule_game = get_previous_game(3)
        return false unless third_previous_schedule_game
        third_previous_schedule_game.game_date.to_date == @game.game_date.to_date - 4
      end

      def get_previous_game(number)
        if number <= 1
          @previous_schedule_game
        else
          return nil unless @previous_schedule_game
          @previous_schedule_game.get_previous_game(number - 1)
        end
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
        @game.to_s
      end
    end
  end
end
