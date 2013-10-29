module Nba
  module Schedule
    class RestDay; end

    class Calendar
      YEARS = {
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
        YEARS[@year][name.to_sym]
      end

      def months
        YEARS[@year].select{|key, _| self.class.month_syms.include? key}.map {|month, (start, mend)|
          OpenStruct.new(name: month, start: start, end: mend)
        }
      end

      def self.month_syms
        (Date::MONTHNAMES[1..4] + Date::MONTHNAMES[10..12]).map {|month| month.downcase.to_sym}
      end

      def self.get_current_year
        year = YEARS.keys.find do |year|
           Date.today >= YEARS[year][:start] && Date.today <= YEARS[year][:end]
        end
        return year || YEARS.keys.find do |year_key|
          YEARS[year_key.next] && YEARS[year_key.next][:start] > Date.today
        end
      end
    end
  end
end
