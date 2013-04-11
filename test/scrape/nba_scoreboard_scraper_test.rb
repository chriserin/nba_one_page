require './test/test_helper'

class NbaScoreboardScraperTest < MiniTest::Unit::TestCase

  def test_scrape_scoreboard
    urls    = []
    scraper = NbaScoreboardScraper.new

    VCR.use_cassette('scoreboard') do
      urls = scraper.scrape_scoreboard(DateTime.new(2012, 3, 15))
    end

    refute_nil(urls)
    assert urls.size == 5
  end

  def test_run_scoreboard_scraper
    urls = []
    scraper = NbaScoreboardScraper.new

    VCR.use_cassette('multiple_scoreboards') do
      urls = scraper.run(DateTime.new(2012, 3, 15)..DateTime.new(2012, 3, 16))
    end

    refute_nil(urls)
    assert urls.size == 16
  end
end
