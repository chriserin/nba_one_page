require './test/test_helper'

class TeamScheduleTest < MiniTest::Unit::TestCase
  def test_opponent_win_pct
    mock_game = ActiveSupport::OrderedOptions.new
    mock_game.game_date   = Date.new(2012, 11, 11)
    mock_game.game_result = "W"
    mock_game.opponent    = "Brooklyn Nets"

    team_schedule = Nba::Schedule::TeamSchedule.new([mock_game, mock_game], [], "Chicago Bulls", OpenStruct.new(year: "2013"))
    def team_schedule.find_team_schedule(other_team); return OpenStruct.new(wins: 10, losses: 0); end
    assert team_schedule.opponent_win_pct == 1.0
  end

  def test_opponent_win_pct_losses
    mock_game = ActiveSupport::OrderedOptions.new
    mock_game.game_date   = Date.new(2012, 11, 11)
    mock_game.game_result = "L"
    mock_game.opponent    = "Brooklyn Nets"

    team_schedule = Nba::Schedule::TeamSchedule.new([mock_game, mock_game], [], "Chicago Bulls", OpenStruct.new(year: "2013"))
    def team_schedule.find_team_schedule(other_team); return OpenStruct.new(wins: 0, losses: 10); end
    assert team_schedule.opponent_win_pct == 0.0, "opponent_win_pct is #{team_schedule.opponent_win_pct}"
  end
end
