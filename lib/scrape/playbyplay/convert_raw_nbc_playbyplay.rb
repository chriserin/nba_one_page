require './app/scrape/playbyplay/nbc_play'
require './app/scrape/game_info'

module Scrape
  class ConvertRawNbcPlaybyplay
    QUARTER = 0
    TIME = 1
    TEAM = 2
    DESCRIPTION = 3
    AWAY_SCORE = 4
    HOME_SCORE = 5

    def self.convert_plays(*args)
      plays = args.shift
      converted_plays = create_nbc_plays(plays, *args)
      SplitPlays.split(converted_plays)
    end

    def self.create_nbc_plays(plays, *args)
      converted_plays = []

      plays.each do |play|
        if play.size == 6
          game_info = Scrape::GameInfo.new(*args[0..-2])
          converted_plays << Scrape::NbcPlay.new(play[QUARTER], play[TIME], play[TEAM], play[DESCRIPTION], play[AWAY_SCORE], play[HOME_SCORE], game_info)
        end
      end

      return converted_plays
    end
  end
end
