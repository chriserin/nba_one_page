require './test/test_helper'
require './app/scrape/lineups/lineup'

class LineupTest < MiniTest::Unit::TestCase
  def test_init
    lineup = Scrape::Lineup.new(%w{playerA playerB playerC playerD playerE})
    refute_nil lineup
  end

  def test_add_player
    lineup = Scrape::Lineup.new(%w{playerA})
    lineup.add_player("playerB")
    assert_equal 2, lineup.to_a.size
  end

  def test_add_non_uniq_player
    lineup = Scrape::Lineup.new(%w{playerA})
    lineup.add_player("playerA")
    assert_equal 1, lineup.to_a.size
  end

  def test_substitute_player
    lineup = Scrape::Lineup.new(%w{playerA})
    lineup.add_player("playerB")
    new_lineup = lineup.player_exit("playerA")
    assert_equal 1, new_lineup.to_a.size
  end

  def test_piggy_backed_lineup
    #playerA add
    #playerB exit
    #playerC substitute add
    #playerD add referenced
    #playerC add referenced
    #assert lineupA is [playerA, playerB, playerD]
    #assert lineupB is [playerA, playerC, playerD]
    lineupA = Scrape::Lineup.new(["playerA"])
    lineupB = lineupA.player_exit("playerB")
    lineupB.add_substituted_player("playerC")
    lineupB.add_player("playerD")
    lineupB.add_player("playerC")
    assert_equal ["playerA", "playerB", "playerD"], lineupA.to_a
    assert_equal ["playerA", "playerC", "playerD"], lineupB.to_a
  end
end
