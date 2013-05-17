module Scrape
  class SplitPlays
    def self.split(converted_plays)
      #select all splittable plays
      splittable_plays = converted_plays.select {|play| play.is_splittable?}
      #create split plays
      split_plays = splittable_plays.map { |play| play.split_description }.flatten
      #remove original from plays list
      converted_plays -= splittable_plays
      #add split plays to plays list
      converted_plays += split_plays
    end
  end
end
