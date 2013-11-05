require './test/test_helper'
require './lib/scrape/playbyplay/nbc_playbyplay_scraper'
require './lib/scrape/playbyplay/transform_playbyplay_data'
require './app/services/nba'

class NbcPlaybyplayScraperTest < MiniTest::Unit::TestCase
  def test_scrape
    VCR.use_cassette("nbc_playbyplay_scraper_test_test_scrape") do 
      scraper = NbcPlaybyplayScraper.new(RunNothing)
      args = ["http://scores.nbcsports.msnbc.com/nba/pbp.asp?gamecode=2012110219", "CHI", "LAC", DateTime.new(2012, 11, 17)]
      game_rows, home_team, away_team, game_date, playbyplay_type = scraper.scrape(*args)

      assert game_rows.size > 20
    end
  end

  def test_scrape_and_transform
    VCR.use_cassette("nbc_playbyplay_scraper_test_test_scrape") do 
      scraper = NbcPlaybyplayScraper.new(Scrape::TransformPlaybyplayData)
      scraper.run([["http://scores.nbcsports.msnbc.com/nba/pbp.asp?gamecode=2012110219", "Orlando Magic", "Denver Nuggets", DateTime.new(2012, 11, 17)]])

      stretch_type = StretchLine.make_year_type("2013")
      assert_equal 1, PlayModel("2013").where("play_time" => 0).count
      assert_equal 2, stretch_type.make_year_type("2013").where("start" => 0).count
      assert_equal 2, stretch_type.where("start" => 720).count
      assert_equal 2, stretch_type.where("end" => 720).count
      assert_equal 2, stretch_type.where("start" => 1440).count
      assert_equal 2, stretch_type.where("end" => 1440).count
      assert_equal 0, stretch_type.all.count { |line| line.team_players.count < 5}

    end
  end

  class RunNothing
    def self.run(*args); end
  end
end
