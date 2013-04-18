class Scrape::TransformData
  def self.into_descriptive_boxscore(data, *game_info_args)
    game_info = Scrape::GameInfo.new(*game_info_args)
    away_boxscore = Scrape::Boxscore.new(data[0..2], game_info, false)
    home_boxscore = Scrape::Boxscore.new(data[3..5], game_info, true)

    away_boxscore.opponent_boxscore = home_boxscore
    home_boxscore.opponent_boxscore = away_boxscore

    return away_boxscore, home_boxscore, game_info
  end
end

