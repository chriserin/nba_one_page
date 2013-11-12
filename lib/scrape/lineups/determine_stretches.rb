require './lib/scrape/lineups/lineup'
require './lib/scrape/lineups/on_court_stretch'
require './lib/scrape/lineups/sort_plays'

module Scrape
  class DetermineStretches
    extend Scrape::Lineups::SortPlays

    def self.run_plays(plays)
      current_stretch = OnCourtStretch.new

      plays = sort_plays(plays)
      plays = plays.reject {|play| play.is_technical_foul? }
      stretches = plays.map do |play|
        #puts "#{play.seconds_passed} #{play.description}"
        current_stretch = current_stretch.process_play(play)
      end

      stretches = stretches.select {|stretch| stretch.start != stretch.end}

      stretches.uniq
    end
  end
end
