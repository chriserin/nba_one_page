class Array
  def to_teams
    map do |team|
      Nba::Team.get(team)
    end
  end
end

module Nba
  module Place
    def division_place
      index_by_pct(division_teams)
    end

    def conference_place
      index_by_pct(conference_teams)
    end

    def league_place
      index_by_pct(league)
    end

    def division_games_back
      games_back(first_place(division_teams))
    end

    def conference_games_back
      games_back(first_place(conference_teams))
    end

    def league_games_back
      games_back(first_place(league))
    end

    private
    def games_back(leader)
      ((wins - leader.wins) * 0.5 + (leader.losses - losses) * 0.5).abs
    end

    def conference_teams
      TEAMS.conference(conference).to_teams
    end

    def division_teams
      TEAMS.division(div).to_teams
    end

    def league
      TEAMS.keys.to_teams
    end

    def first_place(teams)
      teams.sort_by {|t| t.pct }.reverse.first
    end

    def index_by_pct(teams)
      teams.sort_by {|t| t.pct }.reverse.index(self) + 1
    end
  end
end
