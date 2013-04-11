

class StatFormulasTest < MiniTest::Unit::TestCase
  def test_field_goal_percentage
    gl = LineTypeFactory.get("2013", :game_line).new :field_goals_attempted => 22, :field_goals_made => 7
    assert_in_delta(0.318, gl.field_goal_percentage , 0.01)
  end

  def test_free_throw_percentage
    gl = LineTypeFactory.get("2013", :game_line).new :free_throws_attempted => 22, :free_throws_made => 7
    assert_in_delta(0.318, gl.free_throw_percentage , 0.01)
  end

  def test_threes_percentage
    gl = LineTypeFactory.get("2013", :game_line).new :threes_attempted => 22, :threes_made => 7
    assert_in_delta(0.318, gl.threes_percentage , 0.01)
  end

  def test_assist_percentage
    gl = LineTypeFactory.get("2013", :game_line).new :assists => 1, :team_field_goals => 8, :minutes => 24, :team_minutes => 240, :field_goals_made => 0
    assert_in_delta(25, gl.assist_percentage , 0.01)
  end

  def test_block_percentage
    gl = LineTypeFactory.get("2013", :game_line).new :blocks => 1, :opponent_field_goals_attempted => 9, :opponent_threes_attempted => 1, :minutes => 24, :team_minutes => 240
    assert_in_delta(25, gl.block_percentage , 0.01)
  end

  def test_defensive_rebound_percentage
    gl = LineTypeFactory.get("2013", :game_line).new :defensive_rebounds => 1, :opponent_offensive_rebounds => 4, :team_defensive_rebounds => 4, :minutes => 24, :team_minutes => 240
    assert_in_delta(25, gl.defensive_rebound_percentage , 0.01)
  end

  def test_offensive_rebound_percentage
    gl = LineTypeFactory.get("2013", :game_line).new :offensive_rebounds => 1, :opponent_defensive_rebounds => 4, :team_offensive_rebounds => 4, :minutes => 24, :team_minutes => 240
    assert_in_delta(25, gl.offensive_rebound_percentage , 0.01)
  end

  def test_total_rebound_percentage
    gl = LineTypeFactory.get("2013", :game_line).new :total_rebounds => 1, :opponent_total_rebounds => 4, :team_total_rebounds => 4, :minutes => 24, :team_minutes => 240
    assert_in_delta(25, gl.total_rebound_percentage , 0.01)
  end

  def test_effective_field_goal_percentage
    gl = LineTypeFactory.get("2013", :game_line).new :field_goals_made => 1, :field_goals_attempted => 4, :threes_made => 1
    assert_in_delta(0.375, gl.effective_field_goal_percentage , 0.01)
  end

  def test_game_score
    gl = LineTypeFactory.get("2013", :game_line).new :points => 3, :field_goals_made => 1, :field_goals_attempted => 2, :free_throws_attempted => 2, :free_throws_made => 1, :offensive_rebounds => 1, :defensive_rebounds => 1, :steals => 1, :assists =>1, :blocks => 1, :personal_fouls => 1, :turnovers => 1
    assert_in_delta(3.6, gl.game_score , 0.01)
  end

  def test_unaveraged_possessions
    gl = LineTypeFactory.get("2013", :game_line).new
    fga, fta, o_rebounds, opp_d_rebounds, fg, tos = 5, 5, 5, 5, 5, 5
    assert_in_delta(12.0, gl.unaveraged_possessions(fga, fta, o_rebounds, opp_d_rebounds, fg, tos) , 0.01)
  end

  def possessions_hash
    {:team_field_goals_attempted => 5, :team_free_throws_attempted => 5, :team_offensive_rebounds => 5, :opponent_defensive_rebounds => 5, :team_field_goals => 5, :team_turnovers => 5, :opponent_field_goals_attempted => 5, :opponent_free_throws_attempted => 5, :opponent_offensive_rebounds => 5, :team_defensive_rebounds => 5, :opponent_field_goals_made => 5, :opponent_turnovers => 5 }
  end

  def test_team_possessions
    gl = LineTypeFactory.get("2013", :game_line).new possessions_hash
    assert_in_delta(12.0, gl.team_possessions, 0.01)
  end

  def test_opponent_possessions
    gl = LineTypeFactory.get("2013", :game_line).new possessions_hash
    assert_in_delta(12.0, gl.opponent_possessions, 0.01)
  end

  def test_possessions
    gl = LineTypeFactory.get("2013", :game_line).new possessions_hash
    assert_in_delta(12.0, gl.possessions, 0.01)
  end

  def test_pace
    gl = LineTypeFactory.get("2013", :game_line).new possessions_hash.merge(:team_minutes => 240)
    assert_in_delta(12.0, gl.pace, 0.01)
  end

  def test_steal_percentage
    gl = LineTypeFactory.get("2013", :game_line).new possessions_hash.merge(:team_minutes => 240, :steals => 4, :minutes => 40)
    assert_in_delta(40, gl.steal_percentage, 0.01)
  end

  def test_turnover_percentage
    gl = LineTypeFactory.get("2013", :game_line).new :turnovers => 5, :field_goals_attempted => 10, :free_throws_attempted => 10
    assert_in_delta(26, gl.turnover_percentage, 1)
  end

  def test_true_shooting_percentage
    gl = LineTypeFactory.get("2013", :game_line).new :points => 1, :field_goals_attempted => 1, :free_throws_attempted => 1
    assert_in_delta(0.347, gl.true_shooting_percentage, 0.01)
  end

  def test_usage
    gl = LineTypeFactory.get("2013", :game_line).new :field_goals_attempted => 1, :free_throws_attempted => 1, :turnovers => 1, :team_minutes => 240, :minutes => 24, :team_field_goals_attempted => 80, :team_free_throws_attempted => 20, :team_turnovers => 14
    assert_in_delta(4.74, gl.usage, 0.01)
  end
end
