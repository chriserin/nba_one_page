require './app/scrape/boxscore/boxscore_scraper'

class ScoreboardScraper

  def run(scoreboard_dates, url_type = :boxscore)
    all_urls = []

    scoreboard_dates.each do |date|
      all_urls.push(*boxscore_urls(date)) if url_type == :boxscore
      all_urls.push(*playbyplay_urls(date)) if url_type == :playbyplay
    end

    return all_urls
  end

  def boxscore_urls(date)
    agent = Mechanize.new
    boxscore_urls = []

    url = "http://espn.go.com/nba/scoreboard?date=#{date.strftime('%Y%m%d')}"
    agent.get(url) do |page|
      boxscore_urls = page.links_with(:href => %r{boxscore}).map {|link| "http://espn.go.com" + link.href}.uniq
    end

    return boxscore_urls
  end

  def playbyplay_urls(date)
    boxscore_urls(date).map { |url| url.sub("boxscore", "playbyplay") + "&period=0"} #period0 gets playbyplay for all periods
  end

  def nbc_playbyplay_urls(date)
    BoxscoreScraper.new(CreateNbcPlaybyplayUrl).run(boxscore_urls(date))
  end

  class CreateNbcPlaybyplayUrl
    def self.run(data, home_team, away_team, game_date, *args)
      nbc_date = game_date.strftime('%Y%m%d') + Nba::TEAMS[home_team][:home_id]
      url = "http://scores.nbcsports.msnbc.com/nba/pbp.asp?gamecode=#{nbc_date}"
      [url, home_team, away_team, game_date]
    end
  end
end
