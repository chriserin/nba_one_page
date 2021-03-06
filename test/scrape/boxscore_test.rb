require './test/test_helper'
require './lib/scrape/game_info'
require './lib/scrape/boxscore/boxscore'
require './lib/scrape/boxscore/convert_descriptive_boxscore'
require './lib/scrape/boxscore/converted_boxscore'
require './lib/scrape/boxscore/transform_boxscore_data'

class BoxscoreTest < MiniTest::Unit::TestCase

  def test_init
    boxscore = Scrape::Boxscore.new([[]] * 3, Scrape::GameInfo.new, false)
    refute_nil boxscore
  end

  def test_game_info_init
    game_info = Scrape::GameInfo.new(*game_info_args)
    refute_nil game_info
  end

  def test_transform_boxscore_data
    data = [[]] * 6
    away_boxscore, home_boxscore, game_info = Scrape::TransformBoxscoreData.into_descriptive_boxscore(data, game_info_args)
    refute_nil away_boxscore
    refute_nil home_boxscore
    refute_nil game_info
  end

  def test_team_name
    boxscore = Scrape::Boxscore.new([[]] *3, Scrape::GameInfo.new(*game_info_args), false)
    assert boxscore.team == "away_name", "Team was #{boxscore.team}"
  end

  def test_game_date
    boxscore = Scrape::Boxscore.new([[]] *3, Scrape::GameInfo.new(*game_info_args), false)
    assert boxscore.game_date == "2012-01-01", "needed something, was #{boxscore.game_date}"
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

  def test_opponent_name
    boxscore = Scrape::Boxscore.new([[]] *3, Scrape::GameInfo.new(*integratable_game_info_args), false)
    boxscore.opponent_boxscore = Scrape::Boxscore.new([[]] *3, Scrape::GameInfo.new(*integratable_game_info_args), true)
    assert boxscore.opponent            == "Chicago Bulls", "needed Chicago Bulls, was #{boxscore.opponent}"
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
    assert boxscore.team_score == 101
    assert boxscore.opponent_score == 120
    assert boxscore.game_result == "L"
  end

  private
  def game_info_args
    return "home_name", "away_name", DateTime.new(2012, 1, 1), 100, 101, 4, 14, 13
  end

  def integratable_game_info_args
    return "Chicago Bulls", "Brooklyn Nets", DateTime.new(2012, 1, 1), 100, 101, 4, 14, 13
  end
end
