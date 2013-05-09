require './test/test_helper'
require './app/scrape/playbyplay/transform_playbyplay_data'
require './app/scrape/playbyplay/nba_playbyplay_scraper'

class NbaPlaybyplayScraperTest < MiniTest::Unit::TestCase
  def test_playbyplay_scrape
    scraper = NbaPlaybyplayScraper.new nil

    VCR.use_cassette('playbyplay') do
      game_rows, home_team, away_team, game_date = scraper.scrape("http://scores.espn.go.com/nba/playbyplay?gameId=320127004&period=0")
      assert game_rows.size > 20, "game_rows.size should be greater than 20 but is #{game_rows.size}"
      assert game_rows.first.first.is_a? String
      assert home_team == "Bulls"
      assert away_team == "Bucks"
      assert game_date.to_date == Date.new(2012, 1, 27)
    end

  end

  def test_playbyplay_scrape_and_transform
    scraper = NbaPlaybyplayScraper.new Scrape::TransformPlaybyplayData

    VCR.use_cassette('playbyplay') do
      scraper.run(["http://scores.espn.go.com/nba/playbyplay?gameId=320127004&period=0"])
    end
#41-90	5-17	20-33	20	30	50	18	5	9	8	17	 	107

    assert PlayModel.where(team: "Chicago Bulls").count > 0
    assert_equal 41, PlayModel.where(team: "Chicago Bulls").where(is_made_field_goal: true).count
    assert_equal 90, PlayModel.where(team: "Chicago Bulls").where(is_attempted_field_goal: true).count
    assert_equal 5, PlayModel.where(team: "Chicago Bulls").where(is_made_three: true).count
    assert_equal 17, PlayModel.where(team: "Chicago Bulls").where(is_attempted_three: true).count
    assert_equal 20, PlayModel.where(team: "Chicago Bulls").where(is_made_free_throw: true).count
    assert_equal 33, PlayModel.where(team: "Chicago Bulls").where(is_attempted_free_throw: true).count
    assert_equal 20, PlayModel.where(team: "Chicago Bulls").where(is_offensive_rebound: true).count
    assert_equal 30, PlayModel.where(team: "Chicago Bulls").where(is_defensive_rebound: true).count
    assert_equal 50, PlayModel.where(team: "Chicago Bulls").where(is_total_rebound: true).count
    assert_equal 18, PlayModel.where(team: "Chicago Bulls").where(is_assist: true).count
    assert_equal 5, PlayModel.where(team: "Chicago Bulls").where(is_steal: true).count
    assert_equal 9, PlayModel.where(team: "Chicago Bulls").where(is_block: true).count
    assert_equal 10, PlayModel.where(team: "Chicago Bulls").where(is_turnover: true).count
    assert_equal 17, PlayModel.where(team: "Chicago Bulls").where(is_personal_foul: true).count
  end

end
