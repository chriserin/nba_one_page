require './test/test_helper'
require './lib/scrape/lineups/determine_stretches'

class DetermineStretchesTest < MiniTest::Unit::TestCase
  def test_one_play
    playA = TestPlay.new("playerA", false)
    Scrape::DetermineStretches.run_plays [playA]
    assert playA.lineup.to_a.include? "playerA"
  end

  def test_exit_exit_play_should_not_have_lineup
    playA = TestPlay.new("playerA", false)
    playB = TestPlay.new("playerA", true)

    Scrape::DetermineStretches.run_plays [playA, playB]
    assert_nil playB.lineup
  end

  def test_exit_should_have_new_lineup_after_exit
    plays = [
      playA = TestPlay.new("playerA", false),
      playB = TestPlay.new("playerA", true),
      playC = TestPlay.new("playerB", false)
    ]

    Scrape::DetermineStretches.run_plays plays
    assert playC.lineup.to_a.include?("playerB"), "#{playC.lineup.to_a} must include playerB"
    refute_equal playC.lineup, playA.lineup
  end

  def test_five_players_with_exit
    plays = [
      playA = TestPlay.new("playerA", false),
      playC = TestPlay.new("playerB", false),
      TestPlay.new("playerC", false),
      TestPlay.new("playerD", false),
      TestPlay.new("playerE", false),
      TestPlay.new("playerA", true),
      playF = TestPlay.new("playerF", false)
    ]
    Scrape::DetermineStretches.run_plays plays
    assert_equal 5, playF.lineup.to_a.size
  end

  class TestPlay
    attr_accessor :player_name, :lineup
    def initialize(player_name, is_exit)
      @player_name = player_name
      @is_exit = is_exit
    end
    def is_exit?; return @is_exit; end
    def seconds_passed; 0; end
    def method_missing(meth_name, *args); false; end
    def team; "x"; end
  end
end
