require './app/scrape/playbyplay/transform_playbyplay_data'
require './app/scrape/playbyplay/playbyplay_scraper'
require './app/scrape/playbyplay/nbc_playbyplay_scraper'

module Scrape
  class PlaybyplayMain
    def self.scrape(game_date=DateTime.now - 1, playbyplay_type = :nbc)
      urls = get_urls(game_date, playbyplay_type)

      playbyplay_scraper = NbcPlaybyplayScraper.new(Scrape::TransformPlaybyplayData) if playbyplay_type == :nbc
      playbyplay_scraper.run(urls)
    end

    def self.get_urls(game_date, playbyplay_type)
      scoreboard_scraper = ScoreboardScraper.new
      return scoreboard_scraper.nbc_playbyplay_urls(game_date) if playbyplay_type == :nbc
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
