require './test/test_helper'
require './app/scrape/playbyplay_main'

class PlaybyplayMainTest < MiniTest::Unit::TestCase
  def test_scrape_christmas_nbc
    VCR.use_cassette('playbyplay_main_test_scrape_christmas_nbc') do
      Scrape::PlaybyplayMain.scrape(DateTime.new(2012, 12, 25), :nbc)
    end
  end
end
