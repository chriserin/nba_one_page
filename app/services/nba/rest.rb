module Nba
  module Rest
    def rest(game_day, days_length)
      earlier_date = game_day.to_date.prev_day(days_length - 1)
      game_day.to_date.downto(earlier_date).count do |day|
        days_register[day] == Nba::RestDay
      end
    end

    def game_days_in_past(game_day, days_length)
      days_length - rest(game_day, days_length)
    end

    def tally(num_games, num_days, remaining=false)
      games_to_count = select_games(remaining)
      games_to_count.count do |game|
        game_days_in_past(game.game_date, num_days) == num_games
      end
    end

    def opponent_tally(num_games, num_days, remaining=false)
      games_to_count = select_games(remaining)
      games_to_count.count do |game|
        team = Team.get(game.opponent)
        team.game_days_in_past(game.game_date, num_days) == num_games
      end
    end

    private
    def select_games(remaining)
      remaining ? unplayed_games : games
    end
  end
end
