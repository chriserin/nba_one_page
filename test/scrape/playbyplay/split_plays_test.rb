require './test/test_helper'
require './lib/scrape/playbyplay/split_plays'
require './lib/scrape/playbyplay/nbc_play'

class SplitPlaysTest < MiniTest::Unit::TestCase

  def test_nbc_split
    play_desc = "Brandon Bass makes a jump shot from 16 feet out. Rajon Rondo with the assist."
    play = Scrape::NbcPlay.new("1", "10:20", "Bos", play_desc, "score", "home_score", nil)
    play_b = Scrape::NbcPlay.new("1", "10:20", "Bos", "Kevin Garnett makes a jump shot from 16 feet out.", "score", "home_score", nil)
    plays = Scrape::SplitPlays.split([play, play_b])
    assert_equal 3, plays.size
    assert_equal play_b, plays.last
  end
end
