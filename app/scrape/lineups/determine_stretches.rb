require './app/scrape/lineups/lineup'
require './app/scrape/lineups/on_court_stretch'

module Scrape
  class DetermineStretches
    def self.run_plays(plays)
      current_stretch = OnCourtStretch.new

      stretches = plays.map do |play|
        current_stretch = current_stretch.process_play(play)
      end

      stretches.each do |stretch|
        stretch.verify_full_lineups
      end

      stretches.uniq
    end
  end
end
