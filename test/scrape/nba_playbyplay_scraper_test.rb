require './test/test_helper'

class NbaPlaybyplayScraperTest < MiniTest::Unit::TestCase
  def test_playbyplay_scrape
    scraper = NbaPlaybyplayScraper.new nil
    game_rows = []

    VCR.use_cassette('playbyplay') do
      game_rows = scraper.scrape("http://scores.espn.go.com/nba/playbyplay?gameId=320127004&period=0")
    end

    assert game_rows.size > 20, "game_rows.size should be greater than 20 but is #{game_rows.size}"
  end

end
