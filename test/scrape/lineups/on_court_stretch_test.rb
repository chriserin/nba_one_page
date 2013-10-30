require './test/test_helper'
require './lib/scrape/lineups/on_court_stretch'

class OnCourtStretchTest < MiniTest::Unit::TestCase
  def test_init
    stretch = Scrape::OnCourtStretch.new
    refute_nil stretch
  end

  def test_default_time
    play_a = TestPlay.new("Start of 1st Quarter", false, 0)
    play_b = TestPlay.new("playerA", false, 1)
    stretch = Scrape::OnCourtStretch.new
    stretch = stretch.process_play(play_a)
    stretch = stretch.process_play(play_b)
    assert_equal 0, stretch.start
    assert_equal 1, stretch.end
  end

  def test_set_time
    play_a = TestPlay.new("playerA", true, 1)
    stretch = Scrape::OnCourtStretch.new
    stretch.set_time(play_a)
    assert_equal 1, stretch.start
    assert_equal 1, stretch.end
  end

  def test_determine_lineup
    play_a = TestPlay.new("playerA", false, 1)
    stretch = Scrape::OnCourtStretch.new
    new_stretch = stretch.determine_lineup(play_a)
    assert_equal stretch, new_stretch
  end

  def test_determine_lineup_play_creates_new_stretch
    play_a = TestPlay.new("playerA", true, 1)
    stretch = Scrape::OnCourtStretch.new
    new_stretch = stretch.determine_lineup(play_a)
    refute_equal stretch, new_stretch
    assert_equal Hash, new_stretch.lineups.class
  end

  def test_increment_stats
    play_a = TestPlay.new("playerA", false, 1)
    def play_a.is_total_rebound?; true; end

    stretch = Scrape::OnCourtStretch.new
    new_stretch = stretch.process_play(play_a)
    assert_equal 1, new_stretch.to_hash(0, Date.today)[:total_rebounds]
  end

  class TestPlay
    attr_accessor :player_name, :lineup, :seconds_passed
    def initialize(player_name, is_exit, seconds_passed=0)
      @player_name = player_name
      @is_exit = is_exit
      @seconds_passed = seconds_passed
    end
    def is_exit?; return @is_exit; end
    def method_missing(meth, *args); return false; end
    def team; "x"; end
  end
end
