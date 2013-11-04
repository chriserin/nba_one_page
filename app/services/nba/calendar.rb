module Nba
  class RestDay; end

  class Calendar
    SEASONS = {
      "2014.playoffs" => {
        start: Date.new(2013, 4, 17),
        end: Date.new(2013, 6, 22)
      },
      "2014.preseason" => {
        start: Date.new(2013, 10, 5),
        end: Date.new(2013, 10, 28)
      },
      "2013" => {
        start: Date.new(2012, 10, 30),
        end: Date.new(2013, 4, 20),
        january:  [ Date.new(2013, 1, 1), Date.new(2013, 1, 31)],
        november: [ Date.new(2012, 10, 30), Date.new(2012, 11, 30)],
        december: [ Date.new(2012, 12, 1), Date.new(2012, 12, 31)],
        february: [ Date.new(2013, 2, 1), Date.new(2013, 2, 28)],
        march:    [ Date.new(2013, 3, 1), Date.new(2013, 3, 31)],
        april:    [ Date.new(2013, 4, 1), Date.new(2013, 4, 15)],
        all_star_game: Date.new(2013, 2, 13)
      },
      "2014" => {
        start: Date.new(2013, 10, 29),
        end: Date.new(2014, 4, 16),
        all_star_game: Date.new(2014, 2, 16)
      }
    }

    def initialize(year)
      @year = year
    end

    def month(name)
      SEASONS[@year][name.to_sym]
    end

    def months
      SEASONS[@year].select{|key, _| self.class.month_syms.include? key}.map {|month, (start, mend)|
        OpenStruct.new(name: month, start: start, end: mend)
      }
    end

    def self.month_syms
      (Date::MONTHNAMES[1..4] + Date::MONTHNAMES[10..12]).map {|month| month.downcase.to_sym}
    end

    def self.get_current_year
      self.get_season(Date.today)
    end

    def self.season_range(season)
      puts "SEASON #{season}"
      return (SEASONS[season.to_s][:start]..SEASONS[season.to_s][:end])
    end

    def self.get_season(date)
      date = date.to_date
      year = SEASONS.keys.find do |year|
        date >= SEASONS[year][:start] && date <= SEASONS[year][:end]
      end
      return year || SEASONS.keys.find do |year_key|
        SEASONS[year_key.next] && SEASONS[year_key.next][:start] > date
      end
    end
  end
end
