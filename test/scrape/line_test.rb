require './test/test_helper'
require './app/scrape/line'

class LineTest < MiniTest::Unit::TestCase
  def test_init_line
    line = Scrape::TotalLine.new [], ActiveSupport::OrderedOptions.new
    refute_nil line
  end

  def test_team_name
    boxscore = ActiveSupport::OrderedOptions.new
    boxscore[:team] = "team_name"
    line = Scrape::TotalLine.new([], boxscore)
    model_hash = line.to_hash
    assert model_hash[:team] = "team_name"
  end

  def test_has_general_info
    keys = %i{team_division team_conference game_date game_result opponent opponent_division opponent_conference is_home team_score opponent_score team_minutes}
    line = Scrape::TotalLine.new [], ActiveSupport::OrderedOptions.new
    model_hash = line.to_hash
    assert (keys - model_hash.keys).empty?, "Doesn't have all general keys #{(keys - model_hash.keys)}"
  end

  def test_has_statistical_info
    keys = %i{games_started line_name position minutes field_goals_made field_goals_attempted threes_made threes_attempted free_throws_made free_throws_attempted offensive_rebounds defensive_rebounds total_rebounds assists steals blocks turnovers personal_fouls plus_minus points}
    line = Scrape::TotalLine.new [], ActiveSupport::OrderedOptions.new
    model_hash = line.to_hash
    assert (keys - model_hash.keys).empty?, "Doesn't have all statistical keys #{(keys - model_hash.keys)}"
  end

  def test_opponent_line_name
    data = []
    boxscore = ActiveSupport::OrderedOptions.new
    boxscore.opponent_boxscore = ActiveSupport::OrderedOptions.new
    boxscore.opponent = "Team Name"
    boxscore.team = "Opponent Name"

    line = Scrape::OpponentTotalLine.new data, boxscore
    assert line.line_name == "Team Name Opponent", "name #{line.line_name} doesn't match for opponent"
  end

  def test_difference_total_line_name
    data = []
    boxscore = ActiveSupport::OrderedOptions.new
    boxscore.team = "Team Name"
    line = Scrape::DifferenceTotalLine.new data, boxscore
    assert line.line_name == "Team Name Difference", "name #{line.line_name} doesn't match for Difference"
  end

  def test_bench_line_name
    data = []
    boxscore = ActiveSupport::OrderedOptions.new
    boxscore.team = "Team Name"
    line = Scrape::BenchLine.new data, boxscore
    assert line.line_name == "Team Name Bench", "name #{line.line_name} doesn't match for Bench"
  end

  def test_starters_line_name
    data = []
    boxscore = ActiveSupport::OrderedOptions.new
    boxscore.team = "Team Name"
    line = Scrape::StartersLine.new data, boxscore
    assert line.line_name == "Team Name Starters", "name #{line.line_name} doesn't match for Starters"
  end

  def test_total_line_name
    data = []
    boxscore = ActiveSupport::OrderedOptions.new
    boxscore.team = "Team Name"
    line = Scrape::TotalLine.new data, boxscore
    assert line.line_name == "Team Name", "name #{line.line_name} doesn't match for Total"
  end

  TEAM_TURNOVERS = 10
  def test_total_line_turnovers
    data = []
    boxscore = ActiveSupport::OrderedOptions.new
    boxscore.team_turnovers = TEAM_TURNOVERS
    line = Scrape::TotalLine.new data, boxscore
    assert line.turnovers == TEAM_TURNOVERS, "turnovers of #{line.turnovers} should be #{TEAM_TURNOVERS}"
  end

  def test_player_line_turnovers
    data = []
    boxscore = ActiveSupport::OrderedOptions.new
    data[Scrape::Line::TURNOVERS] = TEAM_TURNOVERS
    line = Scrape::PlayerLine.new data, boxscore, true
    assert line.turnovers == TEAM_TURNOVERS, "turnovers of #{line.turnovers} should be #{TEAM_TURNOVERS}"
  end

  def test_aggregate_section_data
    data = [ ["", 10], ["", 10] ]
    boxscore = ActiveSupport::OrderedOptions.new
    line = Scrape::StartersLine.new data, boxscore
    assert line.to_hash[:minutes] == 20, "minutes #{line.to_hash[:minutes]} should have equaled 20"
  end

  def test_total_plus_minus
    data = []
    boxscore = ActiveSupport::OrderedOptions.new
    boxscore.team_score = "100"
    boxscore.opponent_score = "110"
    line = Scrape::TotalLine.new data, boxscore
    assert line.plus_minus == -10, "plus_minus #{line.plus_minus} doesn't match for Total"
  end

  def test_player_plus_minus
    data = []
    data[Scrape::Line::PLUS_MINUS] = -10
    boxscore = ActiveSupport::OrderedOptions.new
    line = Scrape::PlayerLine.new data, boxscore, true
    assert line.plus_minus == -10, "plus_minus #{line.plus_minus} doesn't match for Player"
  end

  def test_opponent_turnovers
    data = []
    boxscore = ActiveSupport::OrderedOptions.new
    boxscore.opponent_boxscore = ActiveSupport::OrderedOptions.new
    boxscore.team_turnovers = 14
    line = Scrape::OpponentTotalLine.new data, boxscore
    assert line.turnovers == 14, "needed 14, was #{line.turnovers} - doesn't match for Opponent"
  end

  def test_opponent_plus_minus
    data = []
    boxscore = ActiveSupport::OrderedOptions.new
    boxscore.opponent_boxscore = ActiveSupport::OrderedOptions.new
    boxscore.team_score = "100"
    boxscore.opponent_score = "110"
    line = Scrape::OpponentTotalLine.new data, boxscore
    assert line.plus_minus == -10, "plus_minus #{line.plus_minus} doesn't match for Opponent"
  end

  def test_player_line_is_starter
    data = []
    boxscore = ActiveSupport::OrderedOptions.new
    line = Scrape::PlayerLine.new data, boxscore, true
    assert line.games_started == 1, "is_starter should be true, was #{line.games_started}"
  end
end
