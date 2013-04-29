require './test/test_helper'

class DifficultyTest < MiniTest::Unit::TestCase
  def test_difficulty
    difficulty = Nba::Schedule::Difficulty.new(0.5, 0.5, true, 1, 1)
    assert difficulty.result == 5.0, "needed 5.0 got #{difficulty.result}"
  end
end
