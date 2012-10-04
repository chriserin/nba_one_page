require 'test_helper'

class ScrapeBoxscoresTest < MiniTest::Unit::TestCase
  def test_scrape
    VCR.use_cassette("scrape_boxscores_test", :record => :new_episodes) do
      ScrapeBoxscores.scrape(DateTime.new 2012, 3, 15)
      games_count = GameLine.where(:is_opponent_total => false, :is_home => true, :is_total => true).count
      assert_equal 5, games_count
    end
  end
end
