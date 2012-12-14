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

end
