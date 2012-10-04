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
    converter.run @boxscore_sections, "Chicago Bulls", "Milwaukee Bucks", DateTime.new(2012, 1, 27), 107, 100
    assert_equal 25, GameLine.all.count
    assert_equal 4, GameLine.where(:is_total => true).count
  end

end
