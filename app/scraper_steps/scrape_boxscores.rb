

class ScrapeBoxscores

  def self.scrape(game_date=DateTime.now - 1)
    scoreboard_scraper = NbaScoreboardScraper.new nil
    urls = scoreboard_scraper.scrape_scoreboard(game_date)
    
    boxscore_scraper = NbaBoxscoreScraper.new(NbaBoxscoreConverter.new)
    boxscore_scraper.run(urls)
  end
end
