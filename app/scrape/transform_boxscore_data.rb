require './app/scrape/boxscore'
require './app/scrape/create_game_lines'
require './app/scrape/game_info'
require './app/scrape/convert_descriptive_boxscore'
require './app/scrape/converted_boxscore'

class Scrape::TransformBoxscoreData
  def self.run(*args)
    converted_away_boxscore, converted_home_boxscore = convert_boxscores(*args)
    Scrape::CreateGameLines.act(converted_home_boxscore)
    Scrape::CreateGameLines.act(converted_away_boxscore)
  end

  def self.convert_boxscores(*args)
    away_boxscore, home_boxscore, game_info = into_descriptive_boxscore(args.shift, *args)
    converted_away_boxscore = Scrape::ConvertDescriptiveBoxscore.into_lines(away_boxscore)
    converted_home_boxscore = Scrape::ConvertDescriptiveBoxscore.into_lines(home_boxscore)
    return converted_away_boxscore, converted_home_boxscore
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
