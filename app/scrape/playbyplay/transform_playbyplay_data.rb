
require './app/scrape/game_info'
require './app/services/nba/base_statistics'
require './app/scrape/playbyplay/play'
require './app/scrape/playbyplay/convert_play'
require './app/scrape/playbyplay/convert_raw_playbyplay'
require './app/scrape/playbyplay/convert_raw_cbs_playbyplay'
require './app/scrape/playbyplay/convert_raw_nbc_playbyplay'
require './app/scrape/playbyplay/verify_plays'

module Scrape
  class TransformPlaybyplayData

    def self.run(*args)
      #check file
      File.open("play_by_play_not_available.txt", "w") {|f| f.write("#{args[1..-1]} ")} and return if args.first.empty?
      #convert arry data into play objects
      plays = Scrape::ConvertRawPlaybyplay.convert_plays(*args) if args.last == :espn
      plays = Scrape::ConvertRawCbsPlaybyplay.convert_plays(*args) if args.last == :cbs
      plays = Scrape::ConvertRawNbcPlaybyplay.convert_plays(*args) if args.last == :nbc
      #reject ignorable plays; convert plays to hash.
      play_hashes = plays.reject {|play| play.is_ignorable?}.map {|play| Scrape::ConvertPlay.to_hash(play)}
      #save plays!
      saved_plays = save_plays(play_hashes)
      #verify plays!
      Scrape::VerifyPlays.verify_saved_plays(saved_plays)
    end

    def self.save_plays(play_hashes)
      play_hashes.map do |play_hash|
        PlayModel.create!(play_hash)
      end
    end
  end
end
