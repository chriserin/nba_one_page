require './lib/scrape/game_info'
require './lib/scrape/error'
require './lib/scrape/playbyplay/convert_play'
require './lib/scrape/playbyplay/convert_raw_nbc_playbyplay'
require './lib/scrape/playbyplay/verify_plays'
require './lib/scrape/lineups/determine_stretches'

module Scrape
  module Playbyplay
    module AssemblyLine

      def self.rows_to_plays(rows, game_info)
        plays = Scrape::ConvertRawNbcPlaybyplay.convert_plays(rows, game_info)
        plays.reject {|play| play.is_ignorable?}
      end

      def self.save_plays(plays, game_date)
        play_hashes = plays.map {|play| Scrape::ConvertPlay.to_hash(play)}
        save_play_hashes(play_hashes, game_date)
      end

      def self.save_play_hashes(play_hashes, game_date)
        play_hashes.map do |play_hash|
          PlayModel(game_date).create!(play_hash)
        end
      end

      def self.verify_plays(play_models)
        Scrape::VerifyPlays.verify_saved_plays(play_models)
      end

      def self.determine_stretches(plays)
        stretches = Scrape::DetermineStretches.run_plays(plays)
      end

      def self.save_stretches(stretches, game_date)
        stretches.each do |stretch|
          if stretch.has_lineups?
            StretchLine(game_date).create! stretch.to_hash(0, game_date)
            StretchLine(game_date).create! stretch.to_hash(1, game_date)
          end
        end
      end

      def self.verify_stretches(stretches)
        stretches.each do |stretch|
          stretch.verify_full_lineups
        end
      end
    end
  end
end
