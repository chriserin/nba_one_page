require './test/test_helper'
require './app/scrape/playbyplay/nbc_playbyplay_scraper'

class NbcPlaybyplayScraperTest < MiniTest::Unit::TestCase
  def test_scrape
    VCR.use_cassette("nbc_playbyplay_scraper_test_test_scrape") do 
      scraper = NbcPlaybyplayScraper.new(RunNothing)
      args = ["http://scores.nbcsports.msnbc.com/nba/pbp.asp?gamecode=2012110219", "CHI", "LAC", DateTime.new(2012, 11, 17)]
      game_rows, home_team, away_team, game_date, playbyplay_type = scraper.scrape(*args)

      assert game_rows.size > 20
    end
  end

  class RunNothing
    def self.run(*args); end
  end
end
