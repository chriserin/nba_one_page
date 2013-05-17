require './test/test_helper'
require './app/scrape/playbyplay/convert_raw_cbs_playbyplay'
require './app/scrape/playbyplay/cbs_play'
require './app/scrape/game_info'

class ConvertRawCbsPlaybyplayTest < MiniTest::Unit::TestCase
  def test_create_cbs_plays
    plays = [["10:20", "10-11", "IND", "player A made Running Jumper"]]
    converted_plays = Scrape::ConvertRawCbsPlaybyplay.create_cbs_plays(plays, "IND", "CHA", DateTime.now, :cbs)
    assert_equal 1, converted_plays.size
    assert_equal "player A made Running Jumper", converted_plays[0].description
  end

  def test_create_cbs_plays_quarter_2
    plays = [["1st Qtr"], ["2nd Qtr"], ["10:20", "10-11", "IND", "player A made Running Jumper"]]
    converted_plays = Scrape::ConvertRawCbsPlaybyplay.create_cbs_plays(plays, "IND", "CHA", DateTime.now, :cbs)
    assert_equal 1, converted_plays.size
    assert_equal 820, converted_plays[0].seconds_passed
  end

  def test_convert_plays
    args = [[["9.0", "93-76", "BOS", "Kris Joseph made Layup"], ["1:16", " ", "BKN", "Personal foul on Deron Williams"], ["6:03", "84-68", "BKN", "Gerald Wallace missed 2nd of 2 Free Throws"]], "BKN", "BOS", DateTime.new(2012, 12, 25), :cbs]
    plays = Scrape::ConvertRawCbsPlaybyplay.convert_plays(*args)
    assert_equal 3, plays.count
    assert_equal "Kris Joseph made Layup", plays[0].description
    assert_equal "Personal foul on Deron Williams", plays[1].description
    assert_equal "Gerald Wallace missed 2nd of 2 Free Throws", plays[2].description
  end
end
