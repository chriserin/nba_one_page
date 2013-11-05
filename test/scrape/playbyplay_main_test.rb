require './test/test_helper'
require './lib/scrape/playbyplay'
require './app/services/nba'

class PlaybyplayTest < MiniTest::Unit::TestCase
  def test_scrape_christmas_nbc
    VCR.use_cassette('playbyplay_main_test_scrape_christmas_nbc') do
      Scrape::Playbyplay.get_plays(Date.new(2012, 12, 25))
    end
  end

  def test_scrape_brazil
    VCR.use_cassette('playbyplay_main_test_scrape_brazil') do
      Scrape::Playbyplay.get_plays(Date.new(2013, 10, 12))
    end
  end

  def test_scrape_tenten
    VCR.use_cassette('playbyplay_main_test_scrape_tenten') do
      Scrape::Playbyplay.get_plays(Date.new(2013, 10, 10))
    end
  end
end
