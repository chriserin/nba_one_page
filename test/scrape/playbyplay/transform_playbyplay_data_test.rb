require './test/test_helper'
require './app/scrape/playbyplay/transform_playbyplay_data'
require './app/scrape/playbyplay/convert_raw_playbyplay'
require './app/scrape/playbyplay/verify_plays'

class TransformPlaybyplayDataTest < MiniTest::Unit::TestCase

  def test_convert_plays
    play_a = ["10:20", "Player A makes three point shot", "10-11", ""]
    plays = [play_a]
    args = [plays, "Chicago Bulls", "Milwaukee Bucks", DateTime.new(2012, 1, 27)]
    converted_plays = Scrape::ConvertRawPlaybyplay.convert_plays(*args)
    refute_nil converted_plays
  end

  def test_convert_plays_quarter_1
    play_a = ["10:20", "Player A makes three point shot", "10-11", ""]
    plays = [play_a]
    args = [plays, "Chicago Bulls", "Milwaukee Bucks", DateTime.new(2012, 1, 27)]
    converted_plays = Scrape::ConvertRawPlaybyplay.convert_plays(*args)
    assert_equal 100, converted_plays.first.seconds_passed
  end

  def test_convert_plays_quarter_2
    play_eoq = ["00:00", "End of the 1st Quarter"]
    play_a = ["10:20", "Player A makes three point shot", "10-11", ""]
    plays = [play_eoq, play_a]
    args = [plays, "Chicago Bulls", "Milwaukee Bucks", DateTime.new(2012, 1, 27)]
    converted_plays = Scrape::ConvertRawPlaybyplay.convert_plays(*args)
    assert_equal 820, converted_plays.first.seconds_passed
  end

  def test_convert_plays_split
    play_a = ["10:20", "Player A blocks Player B layup", "10-11", ""]
    plays = [play_a]
    args = [plays, "Chicago Bulls", "Milwaukee Bucks", DateTime.new(2012, 1, 27)]
    converted_plays = Scrape::ConvertRawPlaybyplay.convert_plays(*args)
    assert_equal converted_plays.size, 2
  end

  def test_verify_free_throws
    play = Scrape::Play.new("00:00", "player a makes free throw 1 of 2", "1-0", "", 1, Scrape::GameInfo.new)
    plays = Scrape::VerifyPlays.verify_free_throws([play])
    assert plays.count == 2
    assert_match /1 of 2/, plays[0].description
    assert_match /2 of 2/, plays[1].description
  end

  def test_find_missing_free_throws
    play = Scrape::Play.new("00:00", "player a makes free throw 1 of 2", "1-0", "", 1, Scrape::GameInfo.new)
    missing_free_throw = Scrape::VerifyPlays.find_missing_free_throw([play])
    refute_nil missing_free_throw
  end

  def test_find_play_with_keyword
    play = OpenStruct.new(description: "player a makes free throw 1 of 2")
    found_play = Scrape::VerifyPlays.find_play_with_keyword([play], "1 of 2")
    refute_nil found_play
  end

  def test_create_play_models
    Scrape::TransformPlaybyplayData.save_plays [play_hash]
    assert_equal PlayModel.count, 1
  end

  def test_full_integration
    play_a = ["10:20", "Player A blocks Player B layup", "10-11", ""]
    plays = [play_a]
    args = [plays, "Chicago Bulls", "Milwaukee Bucks", DateTime.new(2012, 1, 27), :espn]
    Scrape::TransformPlaybyplayData.run(*args)
    assert_equal 2, PlayModel.count
  end

  def test_transform_cbs_plays
    args = [[["1st Qtr"], ["2nd Qtr"], ["10:20", "10-11", "IND", "player A made Running Jumper"]], "IND", "CHA", DateTime.new(2012, 11, 3), :cbs]
    Scrape::VerifyPlays.stubs(:verify_saved_plays).returns({})
    Scrape::TransformPlaybyplayData.run(*args)
    assert_equal 1, PlayModel.count
  end

  def test_transform_nbc_plays
    args = [[["1", "10:20", "Ind", "player A made Running Jumper", "home_score", "away_score"]], "IND", "CHA", DateTime.new(2012, 11, 3), :nbc]
    Scrape::VerifyPlays.stubs(:verify_saved_plays).returns({})
    Scrape::TransformPlaybyplayData.run(*args)
    assert_equal 1, PlayModel.count
  end

  def play_hash
    {
      player_name: "player_name",
      team: "Chicago Bulls",
      opponent: "Milwaukee Bucks",
      game_date: Date.new(2013, 1, 1),
      description: "desc",
      team_score: 20,
      opponent_score: 21,
      score_difference: 1,
      original_description: ""
    }
  end
end
