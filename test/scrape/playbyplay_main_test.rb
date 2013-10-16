require './test/test_helper'
require './app/scrape/playbyplay_main'

class PlaybyplayMainTest < MiniTest::Unit::TestCase
  def test_scrape_christmas_nbc
    VCR.use_cassette('playbyplay_main_test_scrape_christmas_nbc') do
      Scrape::PlaybyplayMain.scrape(DateTime.new(2012, 12, 25), :nbc)
    end
  end

  def test_scrape_brazil
    VCR.use_cassette('playbyplay_main_test_scrape_brazil') do
      Scrape::PlaybyplayMain.scrape(DateTime.new(2013, 10, 12), :nbc)
    end
  end

  def test_scrape_tenten
    VCR.use_cassette('playbyplay_main_test_scrape_tenten') do
      Scrape::PlaybyplayMain.scrape(DateTime.new(2013, 10, 10), :nbc)
    end
  end
end
