module Nba
  class Standings < Array
    def initialize(wins_and_losses)
      calculate_standings(wins_and_losses)
    end

    def first_in_category(division_or_conference)
      categorize(division_or_conference).first
    end

    def categorize(division_or_conference)
      return self if division_or_conference.blank?
      select { |standing| standing.division == division_or_conference || standing.conference == division_or_conference}
    end

    private
    def calculate_standings(wins_and_losses)
      wins_and_losses.group_by{ |line| line.team }.each_pair do |team, games|
        push Nba::Standing.new(team, games, self)
      end
      sort_by! {|standing| standing.win_pct }
      reverse!
    end
  end
end
