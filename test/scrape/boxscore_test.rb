require './test/test_helper'
require './app/scrape/boxscore'
require './app/scrape/convert_descriptive_boxscore'
require './app/scrape/converted_boxscore'
require './app/scrape/game_info'
require './app/scrape/transform_data'

class BoxscoreTest < MiniTest::Unit::TestCase

  def test_init
    boxscore = Scrape::Boxscore.new([[]] * 3, Scrape::GameInfo.new, false)
    refute_nil boxscore
  end

  def test_game_info_init
    game_info = Scrape::GameInfo.new(*game_info_args)
    refute_nil game_info
  end

  def test_transform_data
    data = [[]] * 6
    away_boxscore, home_boxscore, game_info = Scrape::TransformData.into_descriptive_boxscore(data, game_info_args)
    refute_nil away_boxscore
    refute_nil home_boxscore
    refute_nil game_info
  end

  def test_convert_descriptive_boxscore
    boxscore = {}
    converted_boxscore = Scrape::ConvertDescriptiveBoxscore.into_model_hashes(boxscore)
    assert converted_boxscore.total.is_a? Hash
    assert converted_boxscore.opponent_total.is_a? Hash
    assert converted_boxscore.difference_total.is_a? Hash
    assert converted_boxscore.player_lines.is_a? Array
  end

  def test_team_name
    boxscore = Scrape::Boxscore.new([[]] *3, Scrape::GameInfo.new(*game_info_args), false)
    assert boxscore.team == "away_name", "Team was #{boxscore.team}"
  end

  def test_game_date
    boxscore = Scrape::Boxscore.new([[]] *3, Scrape::GameInfo.new(*game_info_args), false)
    assert boxscore.game_date == DateTime.new(2012, 1, 1)
  end

  def test_team_minutes
    boxscore = Scrape::Boxscore.new([[]] *3, Scrape::GameInfo.new(*game_info_args), false)
    assert boxscore.team_minutes == 240, "Team minutes were #{boxscore.team_minutes}"
  end

  def test_opponent
    boxscore = Scrape::Boxscore.new([[]] *3, Scrape::GameInfo.new(*game_info_args), false)
    boxscore.opponent_boxscore = Struct.new(:team, :team_division, :team_conference).new("team", "team_division", "team_conference")
    assert boxscore.opponent            == "team"
    assert boxscore.opponent_division   == "team_division"
    assert boxscore.opponent_conference == "team_conference"
  end

  def test_team_score
    boxscore = Scrape::Boxscore.new([[]] *3, Scrape::GameInfo.new(*game_info_args), false)
    assert boxscore.team_score == 101, "Team score is #{boxscore.team_score}"
  end

  def test_opponent_score
    boxscore = Scrape::Boxscore.new([[]] *3, Scrape::GameInfo.new(*game_info_args), false)
    boxscore.opponent_boxscore = Struct.new(:team_score).new(120)
    assert boxscore.opponent_score == 120
  end

  def test_game_result
    boxscore = Scrape::Boxscore.new([[]] *3, Scrape::GameInfo.new(*game_info_args), false)
    boxscore.opponent_boxscore = Struct.new(:team_score).new(120)
    assert boxscore.game_result == "L"
  end

  private
  def game_info_args
    return "home_name", "away_name", DateTime.new(2012, 1, 1), 100, 101, 4, 14, 13
  end

end
