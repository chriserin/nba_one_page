require './test/test_helper'
require './app/scrape/playbyplay/split_plays'
require './app/scrape/playbyplay/play'
require './app/scrape/playbyplay/nbc_play'

class SplitPlaysTest < MiniTest::Unit::TestCase
  def test_split
    play_a = Scrape::Play.new("10:20", "Player A blocks Player B layup", "10-11", "", 2, nil)
    plays = Scrape::SplitPlays.split([play_a])
    assert_equal 2, plays.size
  end

  def test_nbc_split
    play_desc = "Brandon Bass makes a jump shot from 16 feet out. Rajon Rondo with the assist."
    play = Scrape::NbcPlay.new("1", "10:20", "Bos", play_desc, "score", "home_score", nil)
    play_b = Scrape::NbcPlay.new("1", "10:20", "Bos", "Kevin Garnett makes a jump shot from 16 feet out.", "score", "home_score", nil)
    plays = Scrape::SplitPlays.split([play, play_b])
    assert_equal 3, plays.size
    assert_equal play_b, plays.last
  end
end
