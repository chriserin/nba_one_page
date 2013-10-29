require './lib/scrape/game_info'
require './lib/scrape/error'
require './app/services/nba/base_statistics'
require './lib/scrape/playbyplay/convert_play'
require './lib/scrape/playbyplay/convert_raw_nbc_playbyplay'
require './lib/scrape/playbyplay/verify_plays'
require './lib/scrape/lineups/determine_stretches'

module Scrape
  class TransformPlaybyplayData

    def self.run(*args)
      #check file
      File.open("play_by_play_not_available.txt", "w") {|f| f.write("#{args[1..-1]} ")} and return if args.first.empty?
      #convert arry data into play objects
      plays = Scrape::ConvertRawNbcPlaybyplay.convert_plays(*args) if args.last == :nbc
      #reject ignorable plays; convert plays to hash.
      non_ignored_plays = plays.reject {|play| play.is_ignorable?}
      play_hashes = non_ignored_plays.map {|play| Scrape::ConvertPlay.to_hash(play)}

      saved_plays = save_plays(play_hashes)
      Scrape::VerifyPlays.verify_saved_plays(saved_plays)

      stretches = Scrape::DetermineStretches.run_plays(non_ignored_plays)
      save_stretches(stretches)
    end

    def self.save_plays(play_hashes)
      play_hashes.map do |play_hash|
        PlayModel.create!(play_hash)
      end
    end

    def self.save_stretches(stretches)
      LineTypeFactory
      stretches.each do |stretch|
        if stretch.has_lineups?
          StretchLine.create! stretch.to_hash(0)
          StretchLine.create! stretch.to_hash(1)
        end
      end
    end
  end
end
