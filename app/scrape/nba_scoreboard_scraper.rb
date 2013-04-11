
class NbaScoreboardScraper

  def run(scoreboard_dates)
    all_urls = []

    scoreboard_dates.each do |date|
      all_urls.push(*scrape_scoreboard(date))
    end

    return all_urls
  end

  def scrape_scoreboard(date)
    agent = Mechanize.new
    boxscore_urls = []

    agent.get("http://espn.go.com/nba/scoreboard?date=#{date.strftime('%Y%m%d')}") do |page|
      boxscore_urls = page.links_with(:href => %r{boxscore}).map {|link| "http://espn.go.com" + link.href}.uniq
    end

    return boxscore_urls
  end
end
