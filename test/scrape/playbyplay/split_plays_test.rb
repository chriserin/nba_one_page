require './test/test_helper'
require './app/scrape/playbyplay/split_plays'
require './app/scrape/playbyplay/play'

class SplitPlaysTest < MiniTest::Unit::TestCase
  def test_split
    play_a = Scrape::Play.new("10:20", "Player A blocks Player B layup", "10-11", "", 2, nil)
    plays = Scrape::SplitPlays.split([play_a])
    assert_equal 2, plays.size
  end
end
