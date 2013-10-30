require './lib/scrape/boxscore/transform_boxscore_data'
require './lib/scrape/scoreboard_scraper.rb'

module Scrape
  class BoxscoreMain
    def self.scrape(game_date=DateTime.now - 1, rebuild=true)
      scoreboard_scraper = ScoreboardScraper.new
      urls = scoreboard_scraper.boxscore_urls(game_date)

      boxscore_scraper = BoxscoreScraper.new(Scrape::TransformBoxscoreData)
      boxscore_scraper.run(urls)
    end

    def self.scrape_2013()
      game_line_type = GameLine.make_year_type("2013")
      game_line_type.delete_all

      (DateTime.new(2012, 10, 29)..(DateTime.now - 1)).each do |date|
        self.scrape(date, false)
        sleep(2)
      end
    end

    def self.scrape_year(year="2013")
      game_line_type = GameLine.make_year_type(year)
      game_line_type.delete_all

      (Nba::Schedule::Calendar::YEARS[year][:start]..[Nba::Schedule::Calendar::YEARS[year][:end], Date.today - 1].min).each do |date|
        self.scrape(date, false)
        sleep(2)
      end
    end
  end
end
