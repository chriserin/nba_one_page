require './app/scrape/transform_playbyplay_data'

module Scrape
  class PlaybyplayMain
    def self.scrape(game_date=DateTime.now - 1)
      scoreboard_scraper = ScoreboardScraper.new
      urls = scoreboard_scraper.playbyplay_urls(game_date)

      playbyplay_scraper = PlaybyplayScraper.new(Scrape::TransformPlaybyplayData)
      playbyplay_scraper.run(urls)
    end

    def self.scrape_2013()
      PlayModel.delete_all

      (DateTime.new(2012, 10, 29)..(DateTime.now - 1)).each do |date|
        self.scrape(date)
        sleep(2)
      end
    end
  end
end
