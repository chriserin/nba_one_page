module Nba

  class Schedule
    def initialize(games, standings)
      @team_schedules = {}
      Nba::TEAMS.keys.each do |team|
        team_games = games.select {|game| game.home_team == team or game.away_team == team}
        @team_schedules[team] = Nba::TeamSchedule.new [], team_games, team, standings, self
      end
    end

    def find_team_schedule(team)
      @team_schedules[team]
    end

    def unplayed_games_for_team(team)
      @team_schedules[team].filter_games_by_today
    end
  end

  class TeamSchedule
    attr_accessor :played_games, :unplayed_games, :team

    def initialize(played_games, unplayed_games, team, standings, schedule)
      @played_games, @unplayed_games, @team = played_games, unplayed_games, team

      @wrapped_played_games = []
      @wrapped_unplayed_games = []
      (@played_games + @unplayed_games).sort_by {|g| g.game_date.to_date }.each do |game|
        previous_schedule_game = games.last
        if game.class == GameLine
          @wrapped_played_games.push Nba::ScheduleGame.new(team, game, previous_schedule_game, standings, schedule)
        else
          @wrapped_unplayed_games.push Nba::ScheduleGame.new(team, game, previous_schedule_game, standings, schedule)
        end
      end
    end

    def display_games
      @wrapped_played_games.reverse + (@wrapped_unplayed_games + [Nba::AllStarGame]).sort_by{|g| g.game_date}
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
      filter_wrapped_games_by_today.count {|game| game.difficulty < 6}
    end

    def medium_games_left
      filter_wrapped_games_by_today.count {|game| game.difficulty < 8 and game.difficulty >= 6}
    end

    def hard_games_left
      filter_wrapped_games_by_today.count {|game| game.difficulty >= 8}
    end

    def avg_difficulty_left
      avg_games = filter_wrapped_games_by_today
      (avg_games.map{|game| game.difficulty }.inject(:+) / avg_games.count.to_f).round(1)
    end
  end

  class AllStarGame
    class << self
      def game_description
        "ALL-STAR GAME IN HOUSTON"
      end

      def game; self; end

      def game_date
        "2013-02-17".to_date
      end

      def formatted_game_date
        "02/17"
      end

      def is_opponent_back_to_back?
        false
      end

      def is_opponent_four_in_five?
        false
      end

      def is_back_to_back?
        false
      end

      def is_four_in_five?
        false
      end

      def difficulty
        ""
      end
    end
  end

  class ScheduleGame
    attr_accessor :team, :game, :previous_schedule_game

    def initialize(team, game, previous_schedule_game, standings, schedule)
      @team, @game, @previous_schedule_game, @standings, @schedule = team, game, previous_schedule_game, standings, schedule
    end

    def game_description
      if game.class == GameLine
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

    def inspect
      @game.to_s
    end
  end
end
