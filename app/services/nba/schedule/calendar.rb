module Nba
  module Schedule
    class RestDay; end

    class Calendar
      YEARS = {
        "2013" => {
          start: Date.new(2012, 10, 30),
          end: Date.new(2013, 4, 20),
          all_star_game: Date.new(2013, 2, 13)
        }
      }

      def initialize(year)
        @year = year
        @days = create_days(year)
      end

      def create_days(year)
        year_dates = YEARS[year]
        days = Hash.new
        (year_dates[:start]..year_dates[:end]).each do |date|
          days[date] = RestDay
        end
        days[year_dates[:all_star_game]] = AllStarGame.new(year_dates[:all_star_game])
        return days
      end

      def add_games(games_to_add)
        games_to_add.each do |game|
          @days[game.game_date.to_date] = (block_given? ? yield(game) : game)
        end
      end

      def games
        @days.select {|date, value| value != RestDay and not value.is_a? AllStarGame }.values
      end

      def rest_days_before_date(target_date, days_before=1)
        rest_counter = 0
        days_before.times do |n|
          rest_counter += 1 if @days[target_date.to_date - (n + 1)] == RestDay
        end
        return rest_counter
      end
    end
  end
end
