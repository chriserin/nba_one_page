require 'test_helper'

class FactoriesTest < MiniTest::Unit::TestCase

  def test_game_line
    game_line = Factory.build(:game_line)
    refute_nil(game_line)
    assert_equal(game_line.class, GameLine)
  end

  def test_scheduled_game
    scheduled_game = Factory.build(:scheduled_game)
    refute_nil(scheduled_game)
    assert_equal(scheduled_game.class, ScheduledGame)
  end
end
