require './test/test_helper'

class ScoreboardScraperTest < MiniTest::Unit::TestCase

  def test_scrape_scoreboard
    urls    = []
    scraper = ScoreboardScraper.new

    VCR.use_cassette('scoreboard') do
      urls = scraper.boxscore_urls(DateTime.new(2012, 3, 15))
    end

    refute_nil(urls)
    assert urls.size == 5
  end

  def test_cbs_playbyplay_urls
    urls = []
    scraper = ScoreboardScraper.new
    VCR.use_cassette('cbs_playbyplay_urls') do 
      urls = scraper.cbs_playbyplay_urls(DateTime.new(2012, 11, 2))
    end
    assert_includes urls, "http://www.cbssports.com/nba/gametracker/playbyplay/NBA_20121102_IND@CHA"
  end

  def test_nbc_playbyplay_urls
    urls = []
    scraper = ScoreboardScraper.new
    VCR.use_cassette('nbc_playbyplay_urls') do 
      urls = scraper.nbc_playbyplay_urls(DateTime.new(2012, 11, 2))
    end
    assert_includes urls.map{|url_arr| url_arr.first}, "http://scores.nbcsports.msnbc.com/nba/pbp.asp?gamecode=2012110219"
  end

  def test_run_scoreboard_scraper
    urls = []
    scraper = ScoreboardScraper.new

    VCR.use_cassette('multiple_scoreboards') do
      urls = scraper.run(DateTime.new(2012, 3, 15)..DateTime.new(2012, 3, 16))
    end

    refute_nil(urls)
    assert urls.size == 16
  end
end
