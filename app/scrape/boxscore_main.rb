require './app/scrape/transform_boxscore_data'

class Scrape::BoxscoreMain
  def self.scrape(game_date=DateTime.now - 1, rebuild=true)
    scoreboard_scraper = NbaScoreboardScraper.new
    urls = scoreboard_scraper.boxscore_urls(game_date)

    boxscore_scraper = NbaBoxscoreScraper.new(Scrape::TransformBoxscoreData)
    boxscore_scraper.run(urls)
  end

  def self.scrape_2013()
    game_line_type = LineTypeFactory.get("2013", :game_line)
    game_line_type.delete_all

    (DateTime.new(2012, 10, 29)..(DateTime.now - 1)).each do |date|
      self.scrape(date, false)
      sleep(2)
    end
  end
end
