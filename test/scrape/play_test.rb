require './test/test_helper'

require './app/scrape/game_info'
require './app/scrape/playbyplay/play'

class PlayTest < MiniTest::Unit::TestCase

  def test_init
    play = Scrape::Play.new("10:20", "desc_a", "10-11", "", 2, Scrape::GameInfo.new)
    refute_nil play
  end

  def test_seconds_passed
    play = Scrape::Play.new("10:20", "desc_a", "10-11", "", 2, Scrape::GameInfo.new)
    seconds_passed = play.seconds_passed
    assert seconds_passed == 820, "should be 820 but was #{seconds_passed}"
  end

  def test_determine_description
    play = Scrape::Play.new("10:20", "this_desc", "10-11", "", 2, Scrape::GameInfo.new)
    desc = play.description
    assert desc == "this_desc"
  end

  def test_determine_description_other
    play = Scrape::Play.new("10:20", "", "10-11", "that_desc", 2, Scrape::GameInfo.new)
    desc = play.description
    assert desc == "that_desc"
  end

  def test_away_score
    play = Scrape::Play.new("10:20", "desc_a", "10-11", "", 2, Scrape::GameInfo.new)
    score = play.away_score
    assert score == 10
  end

  def test_home_score
    play = Scrape::Play.new("10:20", "desc_a", "10-11", "", 2, Scrape::GameInfo.new)
    score = play.home_score
    assert score == 11
  end

  def test_is_field_goal_attempted_two_point_shot
    play = Scrape::Play.new("10:20", "Paul Millsap makes 1-foot two point shot", "10-11", "", 2, Scrape::GameInfo.new)
    assert play.is_attempted_field_goal?
    assert play.is_made_field_goal?
  end

  def test_is_free_throw_attempted
    play = Scrape::Play.new("10:20", "Enes Kanter makes free throw 1 of 2", "10-11", "", 2, Scrape::GameInfo.new)
    assert play.is_attempted_free_throw?
    assert play.is_made_free_throw?
  end

  def test_is_three_attempted
    play = Scrape::Play.new("10:20", "Jason Terry makes 25-foot three pointer", "10-11", "", 2, Scrape::GameInfo.new)
    assert play.is_attempted_three?
    assert play.is_made_three?
  end

  def test_is_offensive_rebound?
    play = Scrape::Play.new("10:20", "Enes Kanter offensive rebound", "10-11", "", 2, Scrape::GameInfo.new)
    assert play.is_offensive_rebound?
  end

  def test_is_defensive_rebound?
    play = Scrape::Play.new("10:20", "Rodrigue Beaubois defensive rebound", "10-11", "", 2, Scrape::GameInfo.new)
    assert play.is_defensive_rebound?
  end

  def test_is_total_rebound?
    play = Scrape::Play.new("10:20", "Enes Kanter offensive rebound", "10-11", "", 2, Scrape::GameInfo.new)
    assert play.is_total_rebound?
  end

  def test_is_assist?
    play = Scrape::Play.new("10:20", "Ian Mahinmi makes two point shot (Rodrigue Beaubois assists)", "10-11", "", 2, Scrape::GameInfo.new)
    assert play.is_assist?
  end

  def test_is_steal?
    play = Scrape::Play.new("10:20", "Dominique Jones lost ball (Earl Watson steals)", "10-11", "", 2, Scrape::GameInfo.new)
    assert play.is_steal?
  end

  def test_is_block?
    play = Scrape::Play.new("10:20", "Rodrigue Beaubois blocks Alec Burks's driving layup", "10-11", "", 2, Scrape::GameInfo.new)
    assert play.is_block?
  end

  def test_is_turnover?
    play = Scrape::Play.new("10:20", "Lamar Odom bad pass (Gordon Hayward steals)", "10-11", "", 2, Scrape::GameInfo.new)
    assert play.is_turnover?
  end

  def test_is_personal_foul?
    play = Scrape::Play.new("10:20", "Kevin Garnett offensive foul (Iman Shumpert draws the foul)", "10-11", "", 2, Scrape::GameInfo.new)
    assert play.is_personal_foul?
  end

  def test_is_splittable?
    play = Scrape::Play.new("10:20", "Lamar Odom bad pass (Gordon Hayward steals)", "10-11", "", 2, Scrape::GameInfo.new)
    assert play.is_splittable?
  end

  def test_split_type
    play = Scrape::Play.new("10:20", "Lamar Odom bad pass (Gordon Hayward steals)", "10-11", "", 2, Scrape::GameInfo.new)
    assert play.split_type == Scrape::StatisticalQueries::STEAL
  end

  def test_split_description
    play = Scrape::Play.new("10:20", "Lamar Odom bad pass (Gordon Hayward steals)", "10-11", "", 2, Scrape::GameInfo.new)
    first_play, second_play = play.split_description
    assert first_play.description == "Lamar Odom bad pass"
    assert second_play.description == "Gordon Hayward steals"
  end

  def test_player_name
    play = Scrape::Play.new("10:20", "Enes Kanter offensive rebound", "10-11", "", 2, Scrape::GameInfo.new)
    assert play.player_name == "Enes Kanter"
  end

  def test_player_name_apostrophe
    play = Scrape::Play.new("10:20", "Alec Burks's driving layup", "10-11", "", 2, Scrape::GameInfo.new)
    assert_equal play.player_name, "Alec Burks"
  end

  def test_jumpball
    play_desc = "Jumpball: Drew Gooden vs. Joakim Noah (Shaun Livingston gains possession)"
    play = Scrape::Play.new("10:20", play_desc, "10-11", "", 2, Scrape::GameInfo.new)
    assert_equal play.player_name, ""
  end

  def test_team_offensive_rebound
    play_desc =  "Chicago offensive team rebound"
    play = Scrape::Play.new("10:20", play_desc, "10-11", "", 2, Scrape::GameInfo.new)
    assert_equal play.player_name, "Chicago"
  end

  def test_team_offensive_rebound
    play_desc =  "Ersan Ilyasova offensive goaltending"
    play = Scrape::Play.new("10:20", play_desc, "10-11", "", 2, Scrape::GameInfo.new)
    assert_equal play.player_name, "Ersan Ilyasova"
  end

  def test_team
    play_desc =  "Ersan Ilyasova offensive goaltending"
    play = Scrape::Play.new("10:20", play_desc, "10-11", "", 2, Scrape::GameInfo.new("Bulls", "Bucks"))
    assert_equal "Milwaukee Bucks", play.team
  end

  def test_opponent
    play_desc =  "Ersan Ilyasova offensive goaltending"
    play = Scrape::Play.new("10:20", play_desc, "10-11", "", 2, Scrape::GameInfo.new("Bulls", "Bucks"))
    assert_equal "Chicago Bulls", play.opponent
  end

  def test_empty_personal_foul
    play_desc = "Kyrie Irving (A.J. Price draws the foul )"
    play = Scrape::Play.new("10:20", play_desc, "10-11", "", 2, Scrape::GameInfo.new)
    first_play, second_play = play.split_description
    assert first_play.description == "Kyrie Irving personal foul"
    assert second_play.description == "A.J. Price draws the foul"
  end

  def test_lonely_misses
    play_desc = "Kyrie Irving misses"
    play = Scrape::Play.new("10:20", play_desc, "10-11", "", 2, Scrape::GameInfo.new)
    assert play.is_attempted_field_goal?
  end

  def test_lonely_name
    play_desc = "Kyrie Irving"
    play = Scrape::Play.new("10:20", play_desc, "10-11", "", 2, Scrape::GameInfo.new)
    assert play.is_ignorable?
  end

  def test_shot_clock_turnover_is_not_field_goal_attempt
    play_desc = "shot clock turnover"
    play = Scrape::Play.new("10:20", play_desc, "10-11", "", 2, Scrape::GameInfo.new)
    refute play.is_attempted_field_goal?
    assert play.is_turnover?
  end

  def test_unassigned_bad_pass
    play_desc = "bad pass"
    play = Scrape::Play.new("10:20", play_desc, "10-11", "", 2, Scrape::GameInfo.new)
    refute play.is_turnover?
  end

  def test_defensive_3_seconds
    play_desc = "Rashard Lewis defensive 3-seconds (Technical Foul)"
    play = Scrape::Play.new("10:20", play_desc, "10-11", "", 2, Scrape::GameInfo.new)
    assert_equal "Rashard Lewis", play.player_name
    refute play.is_turnover?
    refute play.is_splittable?
  end
  
  def test_three_point_running_jumper
    play_desc = "Ray Allen makes three point running jumper (Shane Battier assists )"
    play = Scrape::Play.new("10:20", play_desc, "10-11", "", 2, Scrape::GameInfo.new)
    assert play.is_attempted_three?
  end

  def test_first_keyword_index
    play_desc = "Rashard Lewis defensive 3-seconds (Technical Foul)"
    play = Scrape::Play.new("10:20", play_desc, "10-11", "", 2, Scrape::GameInfo.new)
    assert_equal play.first_keyword_index, 14
  end
end
