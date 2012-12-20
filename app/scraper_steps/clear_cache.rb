require 'open-uri'

class ClearCache < ScraperStep
  def run()
    open("http://www.bballnumbers.com/clear_cache")
    rebuild_cache
  end

  def rebuild_cache
    open("http://www.bballnumbers.com/")
    Nba::TEAMS.each do |team, info|
      open(URI.escape "http://www.bballnumbers.com/#{info[:nickname]}")
    end
  end
end
