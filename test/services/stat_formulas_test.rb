

class StatFormulasTest < MiniTest::Unit::TestCase
  def test_field_goal_percentage
    gl = Factory.build :game_line, :field_goals_attempted => 22, :field_goals_made => 7
    assert_in_delta(0.318, gl.field_goal_percentage , 0.01)
  end

  def test_free_throw_percentage
    gl = Factory.build :game_line, :free_throws_attempted => 22, :free_throws_made => 7
    assert_in_delta(0.318, gl.free_throw_percentage , 0.01)
  end

  def test_threes_percentage
    gl = Factory.build :game_line, :threes_attempted => 22, :threes_made => 7
    assert_in_delta(0.318, gl.threes_percentage , 0.01)
  end

  def test_assist_percentage
    gl = Factory.build :game_line, :assists => 1, :team_field_goals => 8, :minutes => 24, :team_minutes => 240, :field_goals_made => 0
    assert_in_delta(25, gl.assist_percentage , 0.01)
  end

  def test_block_percentage
    gl = Factory.build :game_line, :blocks => 1, :opponent_field_goals_attempted => 9, :opponent_threes_attempted => 1, :minutes => 24, :team_minutes => 240
    assert_in_delta(25, gl.block_percentage , 0.01)
  end

  def test_defensive_rebound_percentage
    gl = Factory.build :game_line, :defensive_rebounds => 1, :opponent_offensive_rebounds => 4, :team_defensive_rebounds => 4, :minutes => 24, :team_minutes => 240
    assert_in_delta(25, gl.defensive_rebound_percentage , 0.01)
  end

  def test_offensive_rebound_percentage
    gl = Factory.build :game_line, :offensive_rebounds => 1, :opponent_defensive_rebounds => 4, :team_offensive_rebounds => 4, :minutes => 24, :team_minutes => 240
    assert_in_delta(25, gl.offensive_rebound_percentage , 0.01)
  end

  def test_total_rebound_percentage
    gl = Factory.build :game_line, :total_rebounds => 1, :opponent_total_rebounds => 4, :team_total_rebounds => 4, :minutes => 24, :team_minutes => 240
    assert_in_delta(25, gl.total_rebound_percentage , 0.01)
  end

  def test_effective_field_goal_percentage
    gl = Factory.build :game_line, :field_goals_made => 1, :field_goals_attempted => 4, :threes_made => 1
    assert_in_delta(0.375, gl.effective_field_goal_percentage , 0.01)
  end
end
