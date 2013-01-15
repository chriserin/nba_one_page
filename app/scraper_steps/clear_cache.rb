require 'open-uri'

class ClearCache < ScraperStep
  def run()
    open("http://www.bballnumbers.com/clear_cache")
    rebuild_cache
  end

  def rebuild_cache
    p "rebuilding index"
    open("http://www.bballnumbers.com/")
    Nba::TEAMS.each do |team, info|
      p "rebuilding #{team} page"
      open(URI.escape "http://www.bballnumbers.com/#{info[:nickname]}")
    end
  end
end
