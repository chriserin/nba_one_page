require './test/test_helper'

class CalendarTest < MiniTest::Unit::TestCase

  def test_init_calendar
    calendar = Nba::Schedule::Calendar.new("2013")
    refute_nil calendar
  end

  def test_month_january
    calendar = Nba::Schedule::Calendar.new("2013")
    first_day, last_day = calendar.month(:january)
    assert_equal Date.new(2013, 1, 1), first_day
    assert_equal Date.new(2013, 1, 31), last_day
  end

  def test_month_november
    calendar = Nba::Schedule::Calendar.new("2013")
    first_day, last_day = calendar.month(:november)
    assert_equal Date.new(2012, 10, 30), first_day
    assert_equal Date.new(2012, 11, 30), last_day
  end
end
