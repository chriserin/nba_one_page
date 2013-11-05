require './lib/scrape/playbyplay/nbc_play'
require './lib/scrape/playbyplay/split_plays'
require './lib/scrape/game_info'

module Scrape
  class ConvertRawNbcPlaybyplay
    QUARTER = 0
    TIME = 1
    TEAM = 2
    DESCRIPTION = 3
    AWAY_SCORE = 4
    HOME_SCORE = 5

    def self.convert_plays(plays, game_info)
      converted_plays = create_nbc_plays(plays, game_info)
      SplitPlays.split(converted_plays)
    end

    def self.create_nbc_plays(plays, game_info)
      converted_plays = []

      plays.each do |play|
        if play.size == 6
          converted_plays << Scrape::NbcPlay.new(play[QUARTER],
                                                 play[TIME],
                                                 play[TEAM],
                                                 play[DESCRIPTION],
                                                 play[AWAY_SCORE],
                                                 play[HOME_SCORE],
                                                 game_info)
        end
      end

      converted_plays = converted_plays.reverse if is_reversed?(converted_plays)
      return converted_plays
    end

    def self.is_reversed?(plays)
      first_non_zero_play = plays.find {|play| play.seconds_passed > 0}
      first_non_zero_play.seconds_passed > plays.last.seconds_passed
    end
  end
end
