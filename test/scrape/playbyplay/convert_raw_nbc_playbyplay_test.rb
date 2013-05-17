require './test/test_helper'
require './app/scrape/playbyplay/convert_raw_nbc_playbyplay'

class ConvertRawNbcPlaybyplayTest < MiniTest::Unit::TestCase
  def test_create_nbc_plays
    plays = [["2", "10:20", "team", "2 point Field Goal", "home_score", "away_score"]]
    converted_plays = Scrape::ConvertRawNbcPlaybyplay.create_nbc_plays(plays, "IND", "CHA", DateTime.now, :nbc)
    assert_equal 1, converted_plays.size
    assert_equal "2 point Field Goal", converted_plays[0].description
  end
end
