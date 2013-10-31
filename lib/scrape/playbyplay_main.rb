require './lib/scrape/playbyplay/transform_playbyplay_data'
require './lib/scrape/playbyplay/nbc_playbyplay_scraper'

module Scrape
  class PlaybyplayMain
    def self.scrape(game_date=DateTime.now - 1)
      urls = get_urls(game_date)

      playbyplay_scraper = NbcPlaybyplayScraper.new(Scrape::TransformPlaybyplayData)
      playbyplay_scraper.run(urls)
    end

    def self.get_urls(game_date)
      scoreboard_scraper = ScoreboardScraper.new
      return scoreboard_scraper.nbc_playbyplay_urls(game_date)
    end

    def self.scrape_2013()
      PlayModel.delete_all

      (DateTime.new(2012, 10, 29)..(DateTime.now - 1)).each do |date|
        self.scrape(date)
        sleep(2)
      end
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
