require 'test/test_helper'

class NbaBoxscoreConverterTest < MiniTest::Unit::TestCase

  def setup_boxscore_sections
    @boxscore_sections = []

    VCR.use_cassette('boxscore') do
      scraper = NbaBoxscoreScraper.new nil
      @boxscore_sections, dummy = scraper.scrape("http://scores.espn.go.com/nba/boxscore?gameId=320127004")
    end
  end

  def test_convert
    converter = NbaBoxscoreConverter.new
    converter.run @boxscore_sections, "Chicago Bulls", "Milwaukee Bucks", DateTime.new(2012, 1, 27), 107, 100, 4
    assert_equal 29, GameLine.all.count
    assert_equal 4, GameLine.where(:is_total => true).count
  end

  def test_opponent_stats
    converter = NbaBoxscoreConverter.new
    converter.run @boxscore_sections, "Chicago Bulls", "Milwaukee Bucks", DateTime.new(2012, 1, 27), 107, 100, 4
    refute_nil(GameLine.first.opponent_field_goals_attempted)
    assert_equal(92, GameLine.all[4].opponent_field_goals_attempted)
  end

  def test_team_minutes
    converter = NbaBoxscoreConverter.new
    converter.run @boxscore_sections, "Chicago Bulls", "Milwaukee Bucks", DateTime.new(2012, 1, 27), 107, 100, 4
    assert_equal(240, GameLine.first.team_minutes)
  end

  def test_team_minutes_overtime
    overtime_periods = 5
    converter = NbaBoxscoreConverter.new
    converter.run @boxscore_sections, "Chicago Bulls", "Milwaukee Bucks", DateTime.new(2012, 1, 27), 107, 100, overtime_periods
    assert_equal(265, GameLine.first.team_minutes)
  end

  def test_team_field_goals
    converter = NbaBoxscoreConverter.new
    converter.run @boxscore_sections, "Chicago Bulls", "Milwaukee Bucks", DateTime.new(2012, 1, 27), 107, 100, 4
    refute_nil(GameLine.first.team_field_goals)
    assert_equal(41, GameLine.all[4].team_field_goals)
  end
end
