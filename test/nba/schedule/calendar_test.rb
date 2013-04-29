require './test/test_helper'

class CalendarTest < MiniTest::Unit::TestCase

  def test_init_calendar
    calendar = Nba::Schedule::Calendar.new("2013")
    refute_nil calendar
  end

  def test_add_games
    calendar = Nba::Schedule::Calendar.new("2013")
    game = ActiveSupport::OrderedOptions.new
    game.game_date = Date.new(2013, 1, 1)
    calendar.add_games([game])
    assert calendar.games.first == game
  end

  def test_add_games_with_wrapper
    calendar = Nba::Schedule::Calendar.new("2013")
    game = ActiveSupport::OrderedOptions.new
    game.game_date = Date.new(2013, 1, 1)
    calendar.add_games([game]) {|game| OpenStruct.new(wrapped_game: game)}
    assert calendar.games.first.wrapped_game == game
  end

  def test_rest_days_before_date
    calendar = Nba::Schedule::Calendar.new("2013")
    game = ActiveSupport::OrderedOptions.new
    game.game_date = Date.new(2013, 1, 1)
    calendar.add_games([game]) {|game| OpenStruct.new(wrapped_game: game)}
    rest_days = calendar.rest_days_before_date("2013-1-1", 1)
    assert rest_days == 1, "rest_days should be 1 but is #{rest_days}"
  end

  def test_rest_back_2_back
    calendar = Nba::Schedule::Calendar.new("2013")
    games = [OpenStruct.new(game_date: Date.new(2013, 1, 1)), OpenStruct.new(game_date: Date.new(2013, 1, 2))]
    calendar.add_games(games) {|game| OpenStruct.new(wrapped_game: game)}
    rest_days = calendar.rest_days_before_date("2013-1-2", 1)
    assert rest_days == 0, "rest_days should be 0 but is #{rest_days}"
  end

  def test_rest_4_in_5
    calendar = Nba::Schedule::Calendar.new("2013")
    games = [
      OpenStruct.new(game_date: Date.new(2013, 1, 1)),
      OpenStruct.new(game_date: Date.new(2013, 1, 2)),
      OpenStruct.new(game_date: Date.new(2013, 1, 4)),
      OpenStruct.new(game_date: Date.new(2013, 1, 5))
    ]
    calendar.add_games(games) {|game| OpenStruct.new(wrapped_game: game)}
    rest_days = calendar.rest_days_before_date("2013-1-5", 4)
    assert rest_days == 1, "rest_days should be 1 but is #{rest_days}"
  end

  def test_game_sort
    calendar = Nba::Schedule::Calendar.new("2013")
    games = [
      OpenStruct.new(game_date: "2013-1-2"),
      OpenStruct.new(game_date: "2013-1-5"),
      OpenStruct.new(game_date: "2012-11-1"),
      OpenStruct.new(game_date: "2013-1-4"),
      OpenStruct.new(game_date: "2013-1-1")
    ]
    calendar.add_games(games) {|game| OpenStruct.new(wrapped_game: game)}
    date_of_first_game = calendar.games.first.wrapped_game.game_date.to_date
    assert date_of_first_game == Date.new(2012, 11, 1), "should be 2012/11/1 but was #{date_of_first_game}"
    date_of_last_game = calendar.games.last.wrapped_game.game_date.to_date
    assert date_of_last_game == Date.new(2013, 1, 5), "should be 2013/1/1 but was #{date_of_last_game}"
  end
end
