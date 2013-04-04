require 'test/test_helper'

class NbaBoxscoreConverterTest < MiniTest::Unit::TestCase


  def setup_boxscore_sections
    @boxscore_sections = []

    VCR.use_cassette('boxscore') do
      scraper = NbaBoxscoreScraper.new nil
      @boxscore_sections, dummy = scraper.scrape("http://scores.espn.go.com/nba/boxscore?gameId=320127004")
    end

    @game_line_type = LineTypeFactory.get_line_type("2013", :game_line)
  end

  def test_convert
    converter = NbaBoxscoreConverter.new
    converter.run @boxscore_sections, "Chicago Bulls", "Milwaukee Bucks", DateTime.new(2012, 1, 27), 107, 100, 4, 10, 15
    assert_equal 31, @game_line_type.all.count
    assert_equal 4, @game_line_type.where(:is_total => true, :is_difference_total => false).count
    assert_equal 2, @game_line_type.where(:is_difference_total => true).count
  end


  def test_totals_plus_minus
    converter = NbaBoxscoreConverter.new
    converter.run @boxscore_sections, "Chicago Bulls", "Milwaukee Bucks", DateTime.new(2012, 1, 27), 107, 100, 4, 10, 15
    assert_equal 7, @game_line_type.where(:is_total => true).first.plus_minus.abs
  end

  def test_opponent_stats
    converter = NbaBoxscoreConverter.new
    converter.run @boxscore_sections, "Chicago Bulls", "Milwaukee Bucks", DateTime.new(2012, 1, 27), 107, 100, 4, 10, 15
    refute_nil(@game_line_type.where(:is_difference_total => false).first.opponent_field_goals_attempted)
    assert_equal(92, @game_line_type.where(:is_difference_total => false)[4].opponent_field_goals_attempted)
  end

  def test_team_minutes
    converter = NbaBoxscoreConverter.new
    converter.run @boxscore_sections, "Chicago Bulls", "Milwaukee Bucks", DateTime.new(2012, 1, 27), 107, 100, 4, 10, 15
    assert_equal(240, @game_line_type.first.team_minutes)
  end

  def test_team_minutes_overtime
    overtime_periods = 5
    converter = NbaBoxscoreConverter.new
    converter.run @boxscore_sections, "Chicago Bulls", "Milwaukee Bucks", DateTime.new(2012, 1, 27), 107, 100, overtime_periods, 10, 15
    assert_equal(265, @game_line_type.first.team_minutes)
  end

  def test_team_field_goals
    converter = NbaBoxscoreConverter.new
    converter.run @boxscore_sections, "Chicago Bulls", "Milwaukee Bucks", DateTime.new(2012, 1, 27), 107, 100, 4, 10, 15
    refute_nil(@game_line_type.first.team_field_goals)
    assert_equal(41, @game_line_type.where(:is_difference_total => false)[4].team_field_goals)
  end

  def test_team_field_goals_for_totals
    converter = NbaBoxscoreConverter.new
    converter.run @boxscore_sections, "Chicago Bulls", "Milwaukee Bucks", DateTime.new(2012, 1, 27), 107, 100, 4, 10, 15
    refute_nil(@game_line_type.first.team_field_goals)
    assert_equal(41, @game_line_type.where("line_name" => "Chicago Bulls").all[0].team_field_goals)
  end

  def test_games_started
    converter = NbaBoxscoreConverter.new
    converter.run @boxscore_sections, "Chicago Bulls", "Milwaukee Bucks", DateTime.new(2012, 1, 27), 107, 100, 4, 10, 15
    refute_nil(@game_line_type.first.games_started)
    assert_equal(12, @game_line_type.where("games_started" => 1).size)
  end

  def test_team_field_goals_for_totals
    converter = NbaBoxscoreConverter.new
    converter.run @boxscore_sections, "Chicago Bulls", "Milwaukee Bucks", DateTime.new(2012, 1, 27), 107, 100, 4, 10, 15
    refute_nil(@game_line_type.first.team_field_goals)
    assert_equal(10, @game_line_type.where("line_name" => "Chicago Bulls").all[0].team_turnovers)
  end

  def test_difference_line_created
    converter = NbaBoxscoreConverter.new
    converter.run @boxscore_sections, "Chicago Bulls", "Milwaukee Bucks", DateTime.new(2012, 1, 27), 107, 100, 4, 10, 15
    refute_nil(@game_line_type.where("is_difference_total" => true).first)
    assert_equal(@game_line_type.where("is_difference_total" => true).first.line_name, "Chicago Bulls Difference")
  end
end
