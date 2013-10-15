require './app/scrape/game_info'
require './app/scrape/error'
require './app/services/nba/base_statistics'
require './app/scrape/playbyplay/play'
require './app/scrape/playbyplay/convert_play'
require './app/scrape/playbyplay/convert_raw_playbyplay'
require './app/scrape/playbyplay/convert_raw_cbs_playbyplay'
require './app/scrape/playbyplay/convert_raw_nbc_playbyplay'
require './app/scrape/playbyplay/verify_plays'
require './app/scrape/lineups/determine_stretches'

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
      #save plays!
      saved_plays = save_plays(play_hashes)
      #verify plays!
      Scrape::VerifyPlays.verify_saved_plays(saved_plays)
      #determine on court stretches
      stretches = Scrape::DetermineStretches.run_plays(non_ignored_plays)
      #save on court stretches
      save_stretches(stretches)
    rescue Scrape::Error => scrape_error
      Rails.logger.error(scrape_error.message + args[1..-1].inspect)
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
