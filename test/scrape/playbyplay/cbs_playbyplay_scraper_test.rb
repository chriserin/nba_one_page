require './test/test_helper'
require './app/scrape/playbyplay/cbs_playbyplay_scraper'

class CbsPlaybyplayScraperTest < MiniTest::Unit::TestCase
  def test_scrape
    VCR.use_cassette("cbs_playbyplay_scraper_test_test_scrape") do 
      scraper = CbsPlaybyplayScraper.new(RunNothing)
      game_rows, home_team, away_team, game_date, playbyplay_type = scraper.scrape("http://www.cbssports.com/nba/gametracker/playbyplay/NBA_20130513_MIA@CHI")

      assert game_rows.size > 20
      assert game_rows[3].size == 4
      assert_equal game_rows[3][0], "11:40"
      assert_equal game_rows[3][1], "0-0"
      assert_equal game_rows[3][2], "CHI"
      assert_equal game_rows[3][3], "Marco Belinelli missed 3-pt. Jump Shot"

      assert_equal "CHI", home_team
      assert_equal "MIA", away_team
      assert_equal game_date.to_date, "2013-5-13".to_date
    end
  end

  class RunNothing
    def self.run(*args); end
  end
end
