module Nba
  module DifficultyCounts
    LEVELS = {
      easy: [0, 5],
      medium: [5, 7],
      hard: [7, 100]
    }

    def method_missing(meth, *args, &block)
      if meth.to_s.include? "_games_remaining"
        level = meth.to_s.gsub("_games_remaining", "")
        low, high = LEVELS[level.to_sym]
        unplayed_games.count {|game| difficulty(game) >= low && difficulty(game) < high}
      else
        super(meth, *args, &block)
      end
    end
  end
end
