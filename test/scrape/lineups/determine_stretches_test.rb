require './test/test_helper'
require './lib/scrape/lineups/determine_stretches'

class DetermineStretchesTest < MiniTest::Unit::TestCase
  def test_stretch
    playA = TestPlay.new("playerA", false, 20)
    playB = TestPlay.new("playerA", false, 40)
    Scrape::DetermineStretches.run_plays [playA, playB]
    assert playA.lineup.to_a.include? "playerA"
  end

  class TestPlay
    attr_accessor :player_name, :lineup
    def initialize(player_name, is_exit, seconds)
      @player_name = player_name
      @is_exit = is_exit
      @seconds = seconds
    end
    def is_exit?; return @is_exit; end
    def seconds_passed; 60; end
    def method_missing(meth_name, *args); false; end
    def team; "x"; end
    def respond_to?(a, b)
      false
    end
  end
end
