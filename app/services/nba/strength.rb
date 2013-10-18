module Nba
  module Strength
    def strength(num=10)
      wins = last_opponents(num).inject(0) {|total, opp| opp.wins + total}
      losses = last_opponents(num).inject(0) {|total, opp| opp.losses + total}
      wins.to_f / (wins + losses)
    end
  end
end
