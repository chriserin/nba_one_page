require './test/test_helper.rb'

#TODO: Rewrite with Scrape::GameInfo
class BoxscoreScraperTest < MiniTest::Unit::TestCase
  def test_boxscore_sections
    scraper = BoxscoreScraper.new nil
    boxscore_sections = []

    VCR.use_cassette('boxscore') do
      boxscore_sections, dummy = scraper.scrape("http://scores.espn.go.com/nba/boxscore?gameId=320127004")
      refute_nil boxscore_sections
    end

    assert_equal boxscore_sections.size, 6

    assert_equal boxscore_sections[0].size, 5
    assert_equal boxscore_sections[1].size, 8
    assert_equal boxscore_sections[2].size, 3

    assert_equal boxscore_sections[3].size, 5
    assert_equal boxscore_sections[4].size, 8
    assert_equal boxscore_sections[5].size, 3
  end

  def test_gamedate
    scraper = BoxscoreScraper.new nil
    boxscore_sections = []
    game_date = nil

    VCR.use_cassette('boxscore') do
      boxscore_sections, dummy, dummy, game_date = scraper.scrape("http://scores.espn.go.com/nba/boxscore?gameId=320127004")
      refute_nil boxscore_sections
    end

    assert_equal DateTime, game_date.class
  end

  def test_team_turnovers
    scraper = BoxscoreScraper.new nil
    boxscore_sections = []
    args = nil

    VCR.use_cassette('boxscore') do
      args = scraper.scrape("http://scores.espn.go.com/nba/boxscore?gameId=320127004")
      refute_nil args.last
    end

    assert_equal 15, args.last
    assert_equal 10, args[-2]
  end
end
