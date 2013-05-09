require './app/scrape/transform_playbyplay_data'

class Scrape::PlaybyplayMain
  def self.scrape(game_date=DateTime.now - 1)
    scoreboard_scraper = NbaScoreboardScraper.new
    urls = scoreboard_scraper.playbyplay_urls(game_date)

    playbyplay_scraper = NbaPlaybyplayScraper.new(Scrape::TransformPlaybyplayData)
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
