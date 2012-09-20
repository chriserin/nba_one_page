require 'test_helper'

class Season < MiniTest::Unit::TestCase
  def test_initialize
    season = Nba::Season.new "2012"
    refute_nil(season)
  end

  def test_standings
    season = Nba::Season.new "2012"
    refute_nil(season.standings)
  end

  def test_total_statistics
    season = Nba::Season.new "2012"
    refute_nil(season.total_statistics_for_team("Bulls"))
  end
end
