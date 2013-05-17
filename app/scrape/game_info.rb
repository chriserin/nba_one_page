module Scrape
  class GameInfo < Struct.new(:home_team,
                              :away_team,
                              :game_date,
                              :home_score,
                              :away_score,
                              :periods,
                              :home_turnovers,
                              :away_turnovers)

    def other_team(team)
      return away_team if team == home_team
      return home_team if team == away_team
    end
  end
end
