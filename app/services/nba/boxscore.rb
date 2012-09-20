module Nba
  class Boxscore < Array
    attr_accessor :team_orientation

    def initialize(lines, team)
      replace lines
      self.team_orientation = team
    end

    def team_lines
      select { |game| game.team =~ /#{team_orientation}/ }
    end

    def opponent_lines
      select { |game| game.opponent =~ /#{team_orientation}/ }
    end
  end
end
