

class ScrapeBoxscores

  def self.scrape(game_date=DateTime.now - 1)
    scoreboard_scraper = NbaScoreboardScraper.new nil
    urls = scoreboard_scraper.scrape_scoreboard(game_date)

    boxscore_scraper = NbaBoxscoreScraper.new(NbaBoxscoreConverter.new)
    boxscore_scraper.run(urls)

    #cache_clearer = ClearCache.new
    #cache_clearer.run()
  end

  def self.scrape_2013()
    GameLine.season2013.delete_all
    (DateTime.new(2012, 10, 29)..(DateTime.now - 1)).each do |date|
      self.scrape(date)
      sleep(2)
    end
  end
end
