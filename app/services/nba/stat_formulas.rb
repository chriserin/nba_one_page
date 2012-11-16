module Nba
  module StatFormulas
    def field_goal_percentage(made, attempted)
      made / attempted.to_f
    end

    def assist_percentage(assists, minutes, team_minutes, team_field_goals, field_goals)
      100 * assists / (((minutes / (team_minutes / 5)) * team_field_goals) - field_goals)
    end

    def block_percentage(blocks, team_minutes, minutes, opponent_fg_attempts, opponent_three_attempts)
      100 * (blocks * (team_minutes / 5)) / (minutes * (opponent_fg_attempts - opponent_three_attempts))
    end

    def defensive_rebound_percentage(defensive_rebounds, team_minutes, minutes, team_defensive_rebounds, opponent_offensive_rebounds)
      100 * (defensive_rebounds * (team_minutes / 5)) / (minutes * (team_defensive_rebounds + opponent_offensive_rebounds))
    end

    def effective_field_goal_percentage
      (field_goals + 0.5 * three_point_field_goals) / field_goals_attempted
    end

    def game_score
      points + 0.4 * field_goals - 0.7 * field_goal_attempts - 0.4 * (free_throw_attempts - free_throws) + 0.7 * offensive_rebounds + 0.3 * defensive_rebounds + steals + 0.7 * assists + 0.7 * blocks - 0.4 * personal_fouls - turnovers
    end

    def offensive_rebound_percentage()
      100 * (offensive_rebounds * (team_minutes / 5)) / (minutes * (team_offensive_rebounds + opponent_defensive_rebounds))
    end

    def pace
      48 * ((team_possessions + opponent_possesions) / (2 * (team_minutes / 5)))
    end

    def unaveraged_possessions
      (field_goal_attempts + 0.4 * free_throw_attempts - 1.07 * (offensive_rebounds / (offensive_rebounds + opponent_defensive_rebounds)) * (field_goal_attempts - field_goals) + turnovers)
    end

    def possessions
      (unaveraged_possessions(opponent_stats) + unaveraged_possessions(team_stats)) * 0.5
    end

    def steal_percentage
      100 * (steals * (team_minutes / 5)) / (minutes * opponent_possesions)
    end

    def turnover_percentage
      100 * turnovers / (field_goal_attempts + 0.44 * free_throw_attempts + turnovers)
    end

    def total_rebound_percentage
      100 * (total_rebounds * (team_minutes / 5)) / (minutes * (team_total_rebounds + opponent_total_rebounds))
    end

    def true_shooting_percentage
      points / (2 * true_shooting_attempts)
    end

    def true_shooting_attempts
      field_goal_attempts + 0.44 * free_throw_attempts
    end

    def usage
      100 * ((field_goal_attempts + 0.44 * free_throw_attempts + turnovers) * (team_minutes / 5)) / (minutes * (team_field_goal_attempts + 0.44 * team_free_throw_attempts + team_turnovers))
    end
  end
end
