require './test/test_helper'

require './app/scrape/game_info'
require './app/scrape/playbyplay/play'
require './app/scrape/playbyplay/cbs_play'

class CbsPlayTest < MiniTest::Unit::TestCase
  def test_init
    play = Scrape::CbsPlay.new("10:20", "10-11", "IND", "some_desc", 2, Scrape::GameInfo.new("IND", "CHA"))
    refute_nil play
  end

  def test_seconds_passed
    play = Scrape::CbsPlay.new("10:20", "10-11", "IND", "some_desc", 2, Scrape::GameInfo.new("IND", "CHA"))
    seconds_passed = play.seconds_passed
    assert seconds_passed == 820, "should be 820 but was #{seconds_passed}"
  end

  def test_determine_description
    play = Scrape::CbsPlay.new("10:20", "10-11", "IND", "this_desc", 2, Scrape::GameInfo.new("IND", "CHA"))
    desc = play.description
    assert desc == "this_desc"
  end

  def test_determine_description_other
    play = Scrape::CbsPlay.new("10:20", "10-11", "CHA", "that_desc", 2, Scrape::GameInfo.new("IND", "CHA"))
    desc = play.description
    assert desc == "that_desc"
  end

  def test_away_score
    play = Scrape::CbsPlay.new("10:20", "10-11", "CHA", "that_desc", 2, Scrape::GameInfo.new("IND", "CHA"))
    score = play.away_score
    assert score == 10
  end

  def test_home_score
    play = Scrape::CbsPlay.new("10:20", "10-11", "CHA", "that_desc", 2, Scrape::GameInfo.new("IND", "CHA"))
    score = play.home_score
    assert_equal score, 11
  end

  def test_is_field_goal_attempted_two_point_shot
    play = Scrape::CbsPlay.new("10:20", "10-11", "CHA", "Ben Gordon made Jump Shot", 2, Scrape::GameInfo.new("IND", "CHA"))
    assert play.is_attempted_field_goal?
    assert play.is_made_field_goal?
  end

  def test_is_free_throw_attempted
    play = Scrape::CbsPlay.new("10:20", "10-11", "CHA", "Tyler Hansbrough made 1st of 2 Free Throws", 2, Scrape::GameInfo.new("IND", "CHA"))
    assert play.is_attempted_free_throw?
    assert play.is_made_free_throw?
  end

  def test_is_three_attempted
    play = Scrape::CbsPlay.new("10:20", "10-11", "CHA", "Gerald Henderson made 3-pt. Jump Shot, Assist Kemba Walker", 2, Scrape::GameInfo.new("IND", "CHA"))
    assert play.is_attempted_three?
    assert play.is_made_three?
  end

  def test_is_offensive_rebound?
    play = Scrape::CbsPlay.new("10:20", "10-11", "CHA", "Offensive Rebound by Byron 10:09", 2, Scrape::GameInfo.new("IND", "CHA"))
    assert play.is_offensive_rebound?
  end

  def test_is_defensive_rebound?
    play = Scrape::CbsPlay.new("10:20", "10-11", "CHA", "Defensive Rebound by George 9:35", 2, Scrape::GameInfo.new("IND", "CHA"))
    assert play.is_defensive_rebound?
  end

  def test_is_total_rebound?
    play = Scrape::CbsPlay.new("10:20", "10-11", "CHA", "Defensive Rebound by George 9:35", 2, Scrape::GameInfo.new("IND", "CHA"))
    assert play.is_total_rebound?
  end

  def test_is_assist?
    play = Scrape::CbsPlay.new("10:20", "10-11", "CHA", "David West made Floating Jump Shot, Assist Lance Stephenson", 2, Scrape::GameInfo.new("IND", "CHA"))
    assert play.is_assist?
  end

  def test_is_steal?
    play = Scrape::CbsPlay.new("10:20", "10-11", "CHA", "Lost ball turnover on Ben Gordon, Stolen by Paul George", 2, Scrape::GameInfo.new("IND", "CHA"))
    assert play.is_steal?
  end

  def test_is_block?
    play = Scrape::CbsPlay.new("10:20", "10-11", "CHA", "Tyrus Thomas missed Dunk Shot, Blocked by Ian Mahinmi", 2, Scrape::GameInfo.new("IND", "CHA"))
    assert play.is_block?
  end

  def test_is_turnover?
    play = Scrape::CbsPlay.new("10:20", "10-11", "CHA", "Lost ball turnover on Ben Gordon, Stolen by Paul George", 2, Scrape::GameInfo.new("IND", "CHA"))
    assert play.is_turnover?
  end

  def test_is_personal_foul?
    play = Scrape::CbsPlay.new("10:20", "10-11", "CHA", "Shooting foul on Brendan Haywood", 2, Scrape::GameInfo.new("IND", "CHA"))
    assert play.is_personal_foul?
  end

  def test_is_splittable?
    play = Scrape::CbsPlay.new("10:20", "10-11", "CHA", "Lost ball turnover on Ben Gordon, Stolen by Paul George", 2, Scrape::GameInfo.new("IND", "CHA"))
    assert play.is_splittable?
    assert_equal "Lost ball turnover on Ben Gordon, Stolen by Paul George", play.description
  end

  def test_split_type
    play = Scrape::CbsPlay.new("10:20", "10-11", "CHA", "Lost ball turnover on Ben Gordon, Stolen by Paul George", 2, Scrape::GameInfo.new("IND", "CHA"))
    assert play.split_type == Scrape::CbsStatisticalQueries::STEAL
  end

  def test_split_description
    play = Scrape::CbsPlay.new("10:20", "10-11", "CHA", "Lost ball turnover on Ben Gordon, Stolen by Paul George", 2, Scrape::GameInfo.new("IND", "CHA"))
    first_play, second_play = play.split_description
    assert_equal "Lost ball turnover on Ben Gordon", first_play.description
    assert_equal "Stolen by Paul George", second_play.description
    assert_equal "Charlotte Bobcats", first_play.team
  end

  def test_split_description_assist
    play_desc = "David West made Floating Jump Shot, Assist Lance Stephenson"
    play = Scrape::CbsPlay.new("10:20", "10-11", "CHA", play_desc, 2, Scrape::GameInfo.new("IND", "CHA"))
    first_play, second_play = play.split_description
    assert_equal "David West made Floating Jump Shot", first_play.description
    assert first_play.is_made_field_goal?
    assert second_play.is_assist?
  end

  def test_player_name
    play = Scrape::CbsPlay.new("10:20", "10-11", "CHA", "David West made Floating Jump Shot, Assist Lance Stephenson", 2, Scrape::GameInfo.new("IND", "CHA"))
    assert play.player_name == "David West"
  end

  def test_player_name_name_comes_last
    play_desc = "Lost ball turnover on Roy Hibbert"
    play = Scrape::CbsPlay.new("10:20", "10-11", "CHA", play_desc, 2, Scrape::GameInfo.new("IND", "CHA"))
    assert_equal "Roy Hibbert", play.player_name
  end

  def test_player_name_missed_shot
    play = Scrape::CbsPlay.new("10:20", "10-11", "CHA", "Ian Mahinmi missed Dunk Shot", 2, Scrape::GameInfo.new("IND", "CHA"))
    assert "Ian Mahinmi", play.player_name
    refute play.is_made_field_goal?
  end

  def test_team
    play = Scrape::CbsPlay.new("10:20", "10-11", "CHA", "Ian Mahinmi missed Dunk Shot", 2, Scrape::GameInfo.new("IND", "CHA"))
    assert "Ian Mahinmi", play.player_name
    assert_equal "Charlotte Bobcats", play.team
    refute play.is_ignorable?
  end

  def test_player_name_loose_ball_foul
    play_desc = "Loose ball foul on Jared Sullinger"
    play = Scrape::CbsPlay.new("10:20", "10-11", "CHA", play_desc, 2, Scrape::GameInfo.new("IND", "CHA"))
    assert "Jared Sullinger", play.player_name
  end

  def test_jumpball
    play_desc = "Jumpball received by Byron Mullens"
    play = Scrape::CbsPlay.new("10:20", "10-11", "CHA", play_desc, 2, Scrape::GameInfo.new("IND", "CHA"))
    assert play.is_ignorable?
  end

  def test_shot_clock_turnover_is_not_field_goal_attempt
    play_desc = "24-second shotclock violaton turnover on Patrick Beverley"
    play = Scrape::CbsPlay.new("10:20", "10-11", "CHA", play_desc, 2, Scrape::GameInfo.new("IND", "CHA"))
    refute play.is_attempted_field_goal?
  end

  def test_defensive_3_seconds
    play_desc = "Defensive 3-second Technical foul on Joakim Noah"
    play = Scrape::CbsPlay.new("10:20", "10-11", "CHA", play_desc, 2, Scrape::GameInfo.new("IND", "CHA"))
    assert_equal "Joakim Noah", play.player_name
    refute play.is_turnover?
    refute play.is_splittable?
  end
end
