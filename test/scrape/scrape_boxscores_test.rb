require './test/test_helper'
require './app/scrape/boxscore/scrape_boxscores'

#integration test
class ScrapeBoxscoresTest < MiniTest::Unit::TestCase
  def test_scrape
    VCR.use_cassette("scrape_boxscores_test", :record => :new_episodes) do
      ScrapeBoxscores.scrape(DateTime.new(2012, 3, 15), false)
      games_count = LineTypeFactory.get("2013", :game_line).where(:is_opponent_total => false, :is_home => true, :is_total => true).count
      assert_equal 5, games_count
    end
  end
end
