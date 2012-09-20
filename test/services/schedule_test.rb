require 'test_helper'

class ScheduleTest < MiniTest::Unit::TestCase

  def init_schedule
    played_games = 20.times.map { Factory.build :game_line }
    unplayed_games = 20.times.map { Factory.build :scheduled_game }
    Nba::Schedule.new(played_games, [])
  end

  def test_initialize
    schedule = init_schedule()
    refute_nil(schedule)
  end

  def test_played_games_for_display
    schedule = init_schedule()
    played_games = schedule.send(:played_games_for_display, 5)
    assert(played_games.length, 5)
  end

  def test_games_with_latest_as_middle_returns_correct_number
    schedule = init_schedule()
    games = schedule.games_with_latest_as_middle(10)
    assert_equal(games.length, 10)
    assert_equal(games.first.class, GameLine)
    assert_equal(games.last.class, ScheduledGame)

    #works for odd numbers too
    games = schedule.games_with_latest_as_middle(11)
    assert_equal(games.length, 11)
  end
end
