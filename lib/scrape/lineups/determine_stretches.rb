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
      stretches = plays.enum_for(:each_with_index).map do |play, i|
        retry_count = 0
        begin
          #puts "#{play.seconds_passed} #{play.description}"
          current_stretch = current_stretch.process_play(play)
        rescue Scrape::TooManyPlayersError => error
          retry_count += 1
          if retry_count == 1
            play = plays[i - 60, i].reverse.find {|p| p.is_exit? && p.player_name == error.extra_name}
            o = Object.new
            o.extend Scrape::NbcDescriptionSplitting
            a, b = o.split_description_by_type(play.original_description)
            current_stretch.lineups[play.team].remove_player(b.split('enters')[0].strip)
            retry
          elsif retry_count == 2
            current_stretch.lineups[play.team].remove_random_player
            retry
          else
            raise error
          end
        end
      end

      stretches = stretches.select {|stretch| stretch.start != stretch.end}

      stretches.uniq
    end
  end
end
