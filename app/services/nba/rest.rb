module Nba
  module Rest
    def rest(game_day, days_length)
      game_day.to_date.downto(game_day.to_date.prev_day(days_length - 1)).count do |day|
        days_register[day] == Nba::RestDay
      end
    end

    def game_days_in_past(game_day, days_length)
      days_length - rest(game_day_days_length)
    end
  end
end
