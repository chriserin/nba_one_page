module Nba
  module StatFormulas

    def field_goal_percentage
      goal_percentage(field_goals_made, field_goals_attempted)
    end

    def free_throw_percentage
      goal_percentage(free_throws_made, free_throws_attempted)
    end

    def threes_percentage
      goal_percentage(threes_made, threes_attempted)
    end

    def goal_percentage(made, attempted)
      made / attempted.to_f
    end

    def assist_percentage
      100 * assists / (((minutes.to_f / (team_minutes / 5)) * team_field_goals) - field_goals_made)
    end

    def block_percentage
      100 * (blocks * (team_minutes / 5)) / (minutes.to_f * (opponent_field_goals_attempted - opponent_threes_attempted))
    end

    def rebound_percentage(rebounds, total_rebounds)
      100 * (rebounds * (team_minutes / 5)) / (minutes * (total_rebounds))
    end

    def defensive_rebound_percentage
      rebound_percentage(defensive_rebounds, team_defensive_rebounds + opponent_offensive_rebounds)
    end

    def offensive_rebound_percentage
      rebound_percentage(offensive_rebounds, team_offensive_rebounds + opponent_defensive_rebounds)
    end

    def total_rebound_percentage
      rebound_percentage(total_rebounds, team_total_rebounds + opponent_total_rebounds)
    end

    def effective_field_goal_percentage
      (field_goals_made + 0.5 * threes_made) / field_goals_attempted
    end

    def game_score
      points + 0.4 * field_goals - 0.7 * field_goal_attempts - 0.4 * (free_throw_attempts - free_throws) + 0.7 * offensive_rebounds + 0.3 * defensive_rebounds + steals + 0.7 * assists + 0.7 * blocks - 0.4 * personal_fouls - turnovers
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

    def true_shooting_percentage
      points / (2 * true_shooting_attempts)
    end

    def true_shooting_attempts
      field_goals_attempted + 0.44 * free_throws_attempted
    end

    def usage
      100 * ((field_goal_attempts + 0.44 * free_throw_attempts + turnovers) * (team_minutes / 5)) / (minutes * (team_field_goal_attempts + 0.44 * team_free_throw_attempts + team_turnovers))
    end
  end
end
