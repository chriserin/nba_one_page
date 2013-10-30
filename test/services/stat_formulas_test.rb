

class StatFormulasTest < MiniTest::Unit::TestCase
  def test_field_goal_percentage
    gl = GameLine.make_year_type("2013").new :attempted_field_goals => 22, :made_field_goals => 7
    assert_in_delta(0.318, gl.field_goal_percentage , 0.01)
  end

  def test_free_throw_percentage
    gl = GameLine.make_year_type("2013").new :attempted_free_throws => 22, :made_free_throws => 7
    assert_in_delta(0.318, gl.free_throw_percentage , 0.01)
  end

  def test_threes_percentage
    gl = GameLine.make_year_type("2013").new :attempted_threes => 22, :made_threes => 7
    assert_in_delta(0.318, gl.threes_percentage , 0.01)
  end

  def test_assist_percentage
    gl = GameLine.make_year_type("2013").new :assists => 1, :team_field_goals => 8, :minutes => 24, :team_minutes => 240, :made_field_goals => 0
    assert_in_delta(25, gl.assist_percentage , 0.01)
  end

  def test_block_percentage
    gl = GameLine.make_year_type("2013").new :blocks => 1, :opponent_attempted_field_goals => 9, :opponent_attempted_threes => 1, :minutes => 24, :team_minutes => 240
    assert_in_delta(25, gl.block_percentage , 0.01)
  end

  def test_defensive_rebound_percentage
    gl = GameLine.make_year_type("2013").new :defensive_rebounds => 1, :opponent_offensive_rebounds => 4, :team_defensive_rebounds => 4, :minutes => 24, :team_minutes => 240
    assert_in_delta(25, gl.defensive_rebound_percentage , 0.01)
  end

  def test_offensive_rebound_percentage
    gl = GameLine.make_year_type("2013").new :offensive_rebounds => 1, :opponent_defensive_rebounds => 4, :team_offensive_rebounds => 4, :minutes => 24, :team_minutes => 240
    assert_in_delta(25, gl.offensive_rebound_percentage , 0.01)
  end

  def test_total_rebound_percentage
    gl = GameLine.make_year_type("2013").new :total_rebounds => 1, :opponent_total_rebounds => 4, :team_total_rebounds => 4, :minutes => 24, :team_minutes => 240
    assert_in_delta(25, gl.total_rebound_percentage , 0.01)
  end

  def test_effective_field_goal_percentage
    gl = GameLine.make_year_type("2013").new :made_field_goals => 1, :attempted_field_goals => 4, :made_threes => 1
    assert_in_delta(0.375, gl.effective_field_goal_percentage , 0.01)
  end

  def test_game_score
    gl = GameLine.make_year_type("2013").new :points => 3, :made_field_goals => 1, :attempted_field_goals => 2, :attempted_free_throws => 2, :made_free_throws => 1, :offensive_rebounds => 1, :defensive_rebounds => 1, :steals => 1, :assists =>1, :blocks => 1, :personal_fouls => 1, :turnovers => 1
    assert_in_delta(3.6, gl.game_score , 0.01)
  end

  def test_unaveraged_possessions
    gl = GameLine.make_year_type("2013").new
    fga, fta, o_rebounds, opp_d_rebounds, fg, tos = 5, 5, 5, 5, 5, 5
    assert_in_delta(12.0, gl.unaveraged_possessions(fga, fta, o_rebounds, opp_d_rebounds, fg, tos) , 0.01)
  end

  def possessions_hash
    {:team_attempted_field_goals => 5, :team_attempted_free_throws => 5, :team_offensive_rebounds => 5, :opponent_defensive_rebounds => 5, :team_field_goals => 5, :team_turnovers => 5, :opponent_attempted_field_goals => 5, :opponent_attempted_free_throws => 5, :opponent_offensive_rebounds => 5, :team_defensive_rebounds => 5, :opponent_made_field_goals => 5, :opponent_turnovers => 5 }
  end

  def test_team_possessions
    gl = GameLine.make_year_type("2013").new possessions_hash
    assert_in_delta(12.0, gl.team_possessions, 0.01)
  end

  def test_opponent_possessions
    gl = GameLine.make_year_type("2013").new possessions_hash
    assert_in_delta(12.0, gl.opponent_possessions, 0.01)
  end

  def test_possessions
    gl = GameLine.make_year_type("2013").new possessions_hash
    assert_in_delta(12.0, gl.possessions, 0.01)
  end

  def test_pace
    gl = GameLine.make_year_type("2013").new possessions_hash.merge(:team_minutes => 240)
    assert_in_delta(12.0, gl.pace, 0.01)
  end

  def test_steal_percentage
    gl = GameLine.make_year_type("2013").new possessions_hash.merge(:team_minutes => 240, :steals => 4, :minutes => 40)
    assert_in_delta(40, gl.steal_percentage, 0.01)
  end

  def test_turnover_percentage
    gl = GameLine.make_year_type("2013").new :turnovers => 5, :attempted_field_goals => 10, :attempted_free_throws => 10
    assert_in_delta(26, gl.turnover_percentage, 1)
  end

  def test_true_shooting_percentage
    gl = GameLine.make_year_type("2013").new :points => 1, :attempted_field_goals => 1, :attempted_free_throws => 1
    assert_in_delta(0.347, gl.true_shooting_percentage, 0.01)
  end

  def test_usage
    gl = GameLine.make_year_type("2013").new :attempted_field_goals => 1, :attempted_free_throws => 1, :turnovers => 1, :team_minutes => 240, :minutes => 24, :team_attempted_field_goals => 80, :team_attempted_free_throws => 20, :team_turnovers => 14
    assert_in_delta(4.74, gl.usage, 0.01)
  end
end
