require './app/scrape/playbyplay/cbs_play'
require './app/scrape/playbyplay/split_plays'

module Scrape
  class ConvertRawCbsPlaybyplay
    TIME = 0
    SCORE = 1
    TEAM = 2
    DESCRIPTION = 3

    def self.convert_plays(*args)
      plays = args.shift
      converted_plays = create_cbs_plays(plays, *args)
      SplitPlays.split(converted_plays)
    end

    def self.create_cbs_plays(plays, *args)
      converted_plays = []
      quarter = 0
      plays.each do |play|
        if play.size == 4
          game_info = Scrape::GameInfo.new(*args[0..-2])
          converted_plays << Scrape::CbsPlay.new(play[TIME], play[SCORE], play[TEAM], play[DESCRIPTION], quarter, game_info)
        elsif play.size == 1
          quarter += 1 if play[0].include? "Qtr"
        end
      end
      return converted_plays
    end
  end
end
