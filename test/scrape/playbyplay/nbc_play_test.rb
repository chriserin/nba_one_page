require './test/test_helper'
require './app/scrape/playbyplay/nbc_play'
require './app/scrape/game_info'

class NbcPlayTest < MiniTest::Unit::TestCase
  def test_is_made_field_goal
    play_desc = "J.R. Smith makes a 3-point jump shot from 27 feet out. Iman Shumpert with the assist."
    play = Scrape::NbcPlay.new("1", "time", "team", play_desc, "score", "home_score", nil)
    assert play.is_attempted_field_goal?
    assert play.is_made_field_goal?
  end

  def test_is_attempted_field_goal
    play_desc = "Roy Hibbert misses a jump shot from 12 feet out."
    play = Scrape::NbcPlay.new("1", "time", "team", play_desc, "score", "home_score", nil)
    assert play.is_attempted_field_goal?
  end

  def test_is_attempted_free_throw
    play_desc = "George Hill makes free throw 1 of 2."
    play = Scrape::NbcPlay.new("1", "time", "team", play_desc, "score", "home_score", nil)
    assert play.is_attempted_free_throw?
    assert play.is_made_free_throw?
  end

  def test_is_made_three
    play_desc = "Chris Copeland makes a 3-point jump shot from 27 feet out. Jason Kidd with the assist."
    play = Scrape::NbcPlay.new("1", "time", "team", play_desc, "score", "home_score", nil)
    assert play.is_attempted_three?
    assert play.is_made_three?
  end

  def test_is_attempted_three
    play_desc = "Carmelo Anthony misses a 3-point jump shot from 24 feet out."
    play = Scrape::NbcPlay.new("1", "time", "team", play_desc, "score", "home_score", nil)
    assert play.is_attempted_three?
  end

  def test_is_offensive_rebound
    play_desc = "Iman Shumpert with an offensive rebound."
    play = Scrape::NbcPlay.new("1", "time", "NY", play_desc, "score", "home_score", nil)
    assert play.is_offensive_rebound?
  end

  def test_is_defensive_rebound
    play_desc = "J.R. Smith with a defensive rebound."
    play = Scrape::NbcPlay.new("1", "time", "NY", play_desc, "score", "home_score", nil)
    assert play.is_defensive_rebound?
    assert play.is_total_rebound?
  end

  def test_seconds_elapsed
    play_desc = "Defensive Rebound"
    play = Scrape::NbcPlay.new("1", "10:20", "team", play_desc, "score", "home_score", nil)
    assert 820, play.seconds_passed
  end

  def test_split_description
    play_desc = "Brandon Bass makes a jump shot from 16 feet out. Rajon Rondo with the assist."
    play = Scrape::NbcPlay.new("1", "10:20", "Bos", play_desc, "score", "home_score", nil)
    first_play, second_play = play.split_description
    assert_equal "Brandon Bass makes a jump shot from 16 feet out.", first_play.description
    assert_equal "Rajon Rondo with the assist.", second_play.description
    assert_equal play_desc, first_play.original_description
    assert_equal play_desc, second_play.original_description
    assert_equal "Boston Celtics", first_play.team
    assert_equal "Boston Celtics", second_play.team
  end

  def test_split_description_block
    play_desc = "David West blocks a Raymond Felton jump shot from 4 feet out."
    play = Scrape::NbcPlay.new("1", "10:20", "NY", play_desc, "score", "home_score", Scrape::GameInfo.new("Indiana Pacers", "New York Knicks"))
    first_play, second_play = play.split_description

    assert_equal "David West blocks a", first_play.description
    assert_equal "Raymond Felton jump shot from 4 feet out.", second_play.description
    assert_equal play_desc, first_play.original_description
    assert_equal play_desc, second_play.original_description
    assert_equal "Indiana Pacers", first_play.team
    assert_equal "New York Knicks", second_play.team
  end

  def test_split_description_steal
    play_desc = "Paul George steals the ball from J.R. Smith."
    play = Scrape::NbcPlay.new("1", "10:20", "NY", play_desc, "score", "home_score", Scrape::GameInfo.new("Indiana Pacers", "New York Knicks"))
    first_play, second_play = play.split_description

    assert_equal "Paul George steals the ball", first_play.description
    assert_equal "J.R. Smith turnover", second_play.description
    assert_equal "JR Smith", second_play.player_name
    assert_equal play_desc, first_play.original_description
    assert_equal play_desc, second_play.original_description
    assert_equal "Indiana Pacers", first_play.team
    assert_equal "New York Knicks", second_play.team
  end

  def test_split_substitution
    play_desc = "Substitution: Andrew Nicholson in for Arron Afflalo."
    play = Scrape::NbcPlay.new("1", "10:20", "NY", play_desc, "score", "home_score", Scrape::GameInfo.new("Indiana Pacers", "New York Knicks"))
    first_play, second_play = play.split_description

    assert_equal "Andrew Nicholson enters game", first_play.description
    assert_equal "Arron Afflalo exits game", second_play.description
    assert_equal play_desc, first_play.original_description
    assert_equal play_desc, second_play.original_description
    assert_equal "New York Knicks", first_play.team
    assert_equal "New York Knicks", second_play.team
  end

  def test_is_assist
    play_desc = "Rajon Rondo with the assist."
    play = Scrape::NbcPlay.new("1", "10:20", "Bos", play_desc, "score", "home_score", nil)
    assert play.is_assist?
  end

  def test_is_steal
    play_desc = "Paul George steals the ball"
    play = Scrape::NbcPlay.new("1", "10:20", "Bos", play_desc, "score", "home_score", nil)
    assert play.is_steal?
  end

  def test_is_block
    play_desc = "David West blocks a"
    play = Scrape::NbcPlay.new("1", "10:20", "Bos", play_desc, "score", "home_score", nil)
    assert play.is_block?
  end

  def test_is_turnover
    turnover_plays = [
      "David West with a bad pass turnover: Bad Pass"
    ]
    turnover_plays.each do |play_desc|
      play = Scrape::NbcPlay.new("1", "10:20", "Bos", play_desc, "score", "home_score", nil)
      assert play.is_turnover?
    end
  end

  def test_shot_clock_turnover_not_ind_stat
    play_desc = "Knicks with a turnover: Shot Clock Turnover"
    play = Scrape::NbcPlay.new("1", "10:20", "NY", play_desc, "score", "home_score", nil)
    refute play.is_turnover?
  end

  def test_is_personal_foul
    personal_foul_plays = [
      "Offensive Charge Foul foul committed by J.R. Smith.",
      "Shooting foul committed by Roy Hibbert.",
      "Personal foul committed by Kenyon Martin.",
      "Loose Ball foul committed by Kenyon Martin."
    ]

    personal_foul_plays.each do |play_desc|
      play = Scrape::NbcPlay.new("1", "10:20", "Bos", play_desc, "score", "home_score", nil)
      assert play.is_personal_foul?
    end
  end

  def test_player_name
    player_name_plays = [
      "Roy Hibbert misses a jump shot from 12 feet out.",
      "Shooting foul committed by Roy Hibbert.",
      "Roy Hibbert with an offensive rebound.",
      "Roy Hibbert makes a tip shot from 1 foot out.",
      "Roy Hibbert blocks a",
      "Roy Hibbert steals the ball",
      "Roy Hibbert with the assist.",
      "Roy Hibbert with a traveling turnover: Traveling",
      "Roy Hibbert is charged with a turnover due to a foul.",
      "Roy Hibbert exits game",
      "Roy Hibbert enters game",
      "Roy Hibbert running jump shot from 4 feet out."
    ]
    player_name_plays.each do |play_desc|
      play = Scrape::NbcPlay.new("1", "10:20", "Bos", play_desc, "score", "home_score", nil)
      assert_equal "Roy Hibbert", play.player_name
    end
  end

  def test_is_exit
    play_desc = "Roy Hibbert exits game"
    play = Scrape::NbcPlay.new("1", "10:20", "Bos", play_desc, "score", "home_score", nil)
    assert play.is_exit?
  end

  def test_is_entrance
    play_desc = "Roy Hibbert enters game"
    play = Scrape::NbcPlay.new("1", "10:20", "Bos", play_desc, "score", "home_score", nil)
    assert play.is_entrance?
  end
end
