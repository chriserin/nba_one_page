require 'open-uri'

class ClearCache < ScraperStep
  def run()
    open("http://www.bballnumbers.com/clear_cache")
  end
end
