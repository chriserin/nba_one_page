require 'test_helper'

class ScheduleTest < MiniTest::Unit::TestCase

  def init_schedule
    #half home games, half away games
    played_games = 20.times.map { |i| Factory.build :game_line, :is_home => (i % 2 == 0) }
    unplayed_games = 20.times.map { |i| Factory.build :scheduled_game, :home_team => (i % 2 == 0 ? "Chicago Bulls" : "Denver Nuggets"), :away_team => (i % 2 == 0 ? "Denver Nuggets" : "Chicago Bulls") }
    Nba::Schedule.new(played_games, unplayed_games, "Chicago Bulls")
  end

  def init_schedule_no_played_games
    unplayed_games = 20.times.map { |i| Factory.build :scheduled_game, :home_team => (i % 2 == 0 ? "Chicago Bulls" : "Denver Nuggets"), :away_team => (i % 2 == 0 ? "Denver Nuggets" : "Chicago Bulls") }
    Nba::Schedule.new([], unplayed_games, "Chicago Bulls")
  end

  def test_initialize
    schedule = init_schedule()
    refute_nil(schedule)
    assert_equal(ScheduledGame, schedule.unplayed_games.first.class)
    assert_equal("Chicago Bulls", schedule.team)
  end

  def test_played_games_for_display
    schedule = init_schedule()
    played_games = schedule.send(:played_games_for_display, 10)
    assert_equal(5, played_games.length)
    assert_equal(GameLine, played_games.first.class)
  end

  def test_games_with_latest_as_middle_returns_correct_number
    schedule = init_schedule()
    games = schedule.games_with_latest_as_middle(10)
    assert_equal(10, games.length)
    assert_equal(GameLine, games.last.class)
    assert_equal(ScheduledGame, games.first.class)

    #works for odd numbers too
    games = schedule.games_with_latest_as_middle(11)
    assert_equal(games.length, 11)
  end

  def test_unplayed_games_for_display
    schedule = init_schedule()
    unplayed_games = schedule.send(:unplayed_games_for_display, 10)
    assert_equal(5, unplayed_games.length)
    assert_equal(ScheduledGame, unplayed_games.first.class)
  end

  def test_played_home_games
    schedule = init_schedule()
    games = schedule.played_home_games
    refute_empty(games)
    assert_equal(10, games.count)
    assert_equal(GameLine, games.last.class)
  end

  def test_played_away_games
    schedule = init_schedule()
    games = schedule.played_away_games
    refute_empty(games)
    assert_equal(10, games.count)
    assert_equal(GameLine, games.last.class)
  end

  def test_unplayed_home_games
    schedule = init_schedule()
    games = schedule.unplayed_home_games
    refute_empty(games)
    assert_equal(10, games.count)
    assert_equal(ScheduledGame, games.last.class)
  end

  def test_unplayed_away_games
    schedule = init_schedule()
    games = schedule.unplayed_away_games
    refute_empty(games)
    assert_equal(10, games.count)
    assert_equal(ScheduledGame, games.last.class)
  end

  def test_home_games
    schedule = init_schedule()
    home_games = schedule.home_games
    assert_equal(home_games.count, schedule.all_games.count / 2)
    assert_equal(GameLine, home_games.last.class)
    assert_equal(ScheduledGame, home_games.first.class)
  end

  def test_away_games
    schedule = init_schedule()
    games = schedule.away_games
    assert_equal(schedule.all_games.count / 2, games.count)
    refute(games.last.is_home)
    assert_equal("Chicago Bulls", games.first.away_team)
    assert_equal(GameLine, games.last.class)
    assert_equal(ScheduledGame, games.first.class)
  end

  def test_no_played_games
    schedule = init_schedule_no_played_games()
    date = schedule.date_of_last_game_played
    assert_nil(date)
  end
end
