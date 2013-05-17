require './test/test_helper'
require './app/scrape/game_info'

class GameInfoTest < MiniTest::Unit::TestCase
  def test_other_team
    game_info = Scrape::GameInfo.new("first team", "second team")
    other_team = game_info.other_team("first team")
    assert_equal "second team", other_team

    other_team = game_info.other_team("second team")
    assert_equal "first team", other_team
  end

  def test_other_team_nil

    game_info = Scrape::GameInfo.new("first team", "second team")
    other_team = game_info.other_team "not found"
    assert_nil other_team
  end
end
