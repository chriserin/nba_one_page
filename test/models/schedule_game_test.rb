require 'test_helper'

class ScheduledGameTest < MiniTest::Unit::TestCase

  def test_game_text
    game = Factory.build :scheduled_game
    assert_equal("DEN @ CHI", game.game_text)
  end

end
