require 'open-uri'

class ClearCache < ScraperStep
  def run()
    open("http://www.bballnumbers.com/clear_cache")
    rebuild_cache
  end

  def rebuild_cache(wait_time = 5)
    p "rebuilding index"
    open("http://www.bballnumbers.com/")
    sleep wait_time
    Nba::TEAMS.each do |team, info|
      p "rebuilding #{team} page"
      open(URI.escape "http://www.bballnumbers.com/#{info[:nickname]}")
      sleep wait_time
    end
  end
end
