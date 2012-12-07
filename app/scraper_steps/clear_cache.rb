require 'open-uri'

class ClearCache < ScraperStep
  def run()
    if Rails.env.production
      open("http://www.bballnumbers.com/clear_cache")
    end
  end
end
