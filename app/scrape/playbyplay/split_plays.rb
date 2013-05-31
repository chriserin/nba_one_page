module Scrape
  class SplitPlays
    def self.split(converted_plays)

      converted_plays.each_with_index do |play, index|
        if play.is_splittable? 
          split_plays = play.split_description
          converted_plays[index] = split_plays
        end
      end

      converted_plays.flatten
    end
  end
end
