require File.expand_path("../../game_info", __FILE__)
require File.expand_path("../boxscore", __FILE__)
require File.expand_path("../create_game_lines", __FILE__)
require File.expand_path("../convert_descriptive_boxscore", __FILE__)
require File.expand_path("../converted_boxscore", __FILE__)

module Scrape
  class TransformBoxscoreData
    def self.run(*args)
      converted_away_boxscore, converted_home_boxscore, game_info = convert_boxscores(*args)
      Scrape::CreateGameLines.act(converted_home_boxscore, game_info)
      Scrape::CreateGameLines.act(converted_away_boxscore, game_info)
    end

    def self.convert_boxscores(*args)
      away_boxscore, home_boxscore, game_info = into_descriptive_boxscore(args.shift, *args)
      converted_away_boxscore = Scrape::ConvertDescriptiveBoxscore.into_lines(away_boxscore)
      converted_home_boxscore = Scrape::ConvertDescriptiveBoxscore.into_lines(home_boxscore)
      return converted_away_boxscore, converted_home_boxscore, game_info
    end

    def self.into_descriptive_boxscore(data, *game_info_args)
      game_info = Scrape::GameInfo.new(*game_info_args)
      away_boxscore = Scrape::Boxscore.new(data[0..2], game_info, false)
      home_boxscore = Scrape::Boxscore.new(data[3..5], game_info, true)

      away_boxscore.opponent_boxscore = home_boxscore
      home_boxscore.opponent_boxscore = away_boxscore

      return away_boxscore, home_boxscore, game_info
    end
  end
end
