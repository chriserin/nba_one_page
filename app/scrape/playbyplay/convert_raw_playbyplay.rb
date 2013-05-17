require './app/scrape/playbyplay/split_plays'

module Scrape
  class ConvertRawPlaybyplay
    TIME = 0
    AWAY_DESCRIPTION = 1
    SCORE = 2
    HOME_DESCRIPTION = 3

    def self.convert_plays(*args)
      plays = args.shift
      game_info = Scrape::GameInfo.new(*args)
      quarter = 1


      converted_plays = []
      plays.each do |play|
        if play.size == 4
          converted_plays << Scrape::Play.new(play[TIME], play[AWAY_DESCRIPTION], play[SCORE], play[HOME_DESCRIPTION], quarter, game_info)
        elsif play.size == 2
          quarter += 1 if play[1].include? "Quarter"
        end
      end

      Scrape::SplitPlays.split(converted_plays)
    end
  end
end
