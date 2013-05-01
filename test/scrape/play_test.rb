require './test/test_helper'
require './app/scrape/play'

class PlayTest < MiniTest::Unit::TestCase

  def test_init
    play = Scrape::Play.new("10:20", "desc_a", "10-11", "", 2)
    refute_nil play
  end

  def test_seconds_passed
    play = Scrape::Play.new("10:20", "desc_a", "10-11", "", 2)
    seconds_passed = play.seconds_passed
    assert seconds_passed == 820, "should be 820 but was #{seconds_passed}"
  end

  def test_determine_description
    play = Scrape::Play.new("10:20", "this_desc", "10-11", "", 2)
    desc = play.description
    assert desc == "this_desc"
  end

  def test_determine_description_other
    play = Scrape::Play.new("10:20", "", "10-11", "that_desc", 2)
    desc = play.description
    assert desc == "that_desc"
  end

  def test_away_score
    play = Scrape::Play.new("10:20", "desc_a", "10-11", "", 2)
    score = play.away_score
    assert score == 10
  end

  def test_home_score
    play = Scrape::Play.new("10:20", "desc_a", "10-11", "", 2)
    score = play.home_score
    assert score == 11
  end

  def test_is_field_goal_attempted_two_point_shot
    play = Scrape::Play.new("10:20", "Paul Millsap makes 1-foot two point shot", "10-11", "", 2)
    assert play.is_field_goal_attempted?
    assert play.is_field_goal_made?
  end

  def test_is_free_throw_attempted
    play = Scrape::Play.new("10:20", "Enes Kanter makes free throw 1 of 2", "10-11", "", 2)
    assert play.is_free_throw_attempted?
    assert play.is_free_throw_made?
  end

  def test_is_three_attempted
    play = Scrape::Play.new("10:20", "Jason Terry makes 25-foot three pointer", "10-11", "", 2)
    assert play.is_three_attempted?
    assert play.is_three_made?
  end

  def test_is_offensive_rebound?
    play = Scrape::Play.new("10:20", "Enes Kanter offensive rebound", "10-11", "", 2)
    assert play.is_offensive_rebound?
  end

  def test_is_defensive_rebound?
    play = Scrape::Play.new("10:20", "Rodrigue Beaubois defensive rebound", "10-11", "", 2)
    assert play.is_defensive_rebound?
  end

  def test_is_rebound?
    play = Scrape::Play.new("10:20", "Enes Kanter offensive rebound", "10-11", "", 2)
    assert play.is_rebound?
  end

  def test_is_assist?
    play = Scrape::Play.new("10:20", "Ian Mahinmi makes two point shot (Rodrigue Beaubois assists)", "10-11", "", 2)
    assert play.is_assist?
  end

  def test_is_steal?
    play = Scrape::Play.new("10:20", "Dominique Jones lost ball (Earl Watson steals)", "10-11", "", 2)
    assert play.is_steal?
  end

  def test_is_block?
    play = Scrape::Play.new("10:20", "Rodrigue Beaubois blocks Alec Burks's driving layup", "10-11", "", 2)
    assert play.is_block?
  end

  def test_is_turnover?
    play = Scrape::Play.new("10:20", "Lamar Odom bad pass (Gordon Hayward steals)", "10-11", "", 2)
    assert play.is_turnover?
  end

  def test_is_splittable?
    play = Scrape::Play.new("10:20", "Lamar Odom bad pass (Gordon Hayward steals)", "10-11", "", 2)
    assert play.is_splittable?
  end

  def test_split_type
    play = Scrape::Play.new("10:20", "Lamar Odom bad pass (Gordon Hayward steals)", "10-11", "", 2)
    assert play.split_type == Scrape::StatisticalQueries::STEAL
  end

  def test_split_description
    play = Scrape::Play.new("10:20", "Lamar Odom bad pass (Gordon Hayward steals)", "10-11", "", 2)
    first_play, second_play = play.split_description
    assert first_play.description == "Lamar Odom bad pass"
    assert second_play.description == "Gordon Hayward steals"
  end

  def test_player_name
    play = Scrape::Play.new("10:20", "Enes Kanter offensive rebound", "10-11", "", 2)
    assert play.player_name == "Enes Kanter"
  end

  def test_player_name_apostrophe
    play = Scrape::Play.new("10:20", "Alec Burks's driving layup", "10-11", "", 2)
    assert_equal play.player_name, "Alec Burks"
  end
end
