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

    def team
      Nba::TEAMS[team_lines.first.team][:abbr]
    end

    def opponent
      Nba::TEAMS[opponent_lines.first.team][:abbr]
    end

    def title
      team_lines.first.game_text
    end

    def team_score
      team_lines.first.team_score
    end

    def opponent_score
      team_lines.first.opponent_score
    end

    def game_date
      first.game_date
    end

    def formatted_game_date
      game_date.to_date.strftime("%m%d")
    end
  end
end
