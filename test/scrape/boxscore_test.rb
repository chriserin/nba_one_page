require './test/test_helper'
require './app/scrape/boxscore'

class BoxscoreTest < MiniTest::Unit::TestCase

  def test_init
    boxscore = Scrape::Boxscore.new([[]] * 3, Scrape::GameInfo.new, false)
    refute_nil boxscore
  end

  def test_game_info_init
    game_info = Scrape::GameInfo.new(game_info_args)
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

  private
  def game_info_args
    return "home", "away", DateTime.now, 100, 101, 4, 14, 13
  end

end
