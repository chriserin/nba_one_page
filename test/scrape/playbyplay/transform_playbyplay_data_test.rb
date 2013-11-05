require './test/test_helper'
require './lib/scrape/playbyplay/transform_playbyplay_data'
require './lib/scrape/playbyplay/verify_plays'

class TransformPlaybyplayDataTest < MiniTest::Unit::TestCase

  def test_create_play_models
    Scrape::TransformPlaybyplayData.save_plays [play_hash]
    assert_equal PlayModel("2013").count, 1
  end

  def play_hash
    {
      player_name: "player_name",
      team: "Chicago Bulls",
      opponent: "Milwaukee Bucks",
      game_date: Date.new(2013, 1, 1),
      description: "desc",
      team_score: 20,
      opponent_score: 21,
      score_difference: 1,
      original_description: ""
    }
  end
end
