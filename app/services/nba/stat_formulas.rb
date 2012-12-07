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
      if attempted == 0
        0
      else
        (made / attempted.to_f).round(3)
      end
    end

    def assist_percentage
      (100 * (assists / (((minutes.to_f / (team_minutes / 5)) * team_field_goals) - field_goals_made))).round(2)
    end

    def team_assist_percentage
      (100 * (assists.to_f / field_goals_made)).round(2)
    end

    def block_percentage
      (100 * (blocks * (team_minutes / 5)) / (minutes.to_f * (opponent_field_goals_attempted - opponent_threes_attempted))).round(2)
    end

    def team_block_percentage
      (100 * (blocks.to_f / (opponent_field_goals_attempted - opponent_threes_attempted))).round 2
    end

    def team_rebound_percentage(rebounds, total_rebounds)
      (100 * (rebounds.to_f / total_rebounds)).round(2)
    end

    def team_defensive_rebound_percentage
      team_rebound_percentage(defensive_rebounds, team_defensive_rebounds + opponent_offensive_rebounds)
    end

    def team_offensive_rebound_percentage
      team_rebound_percentage(offensive_rebounds, team_offensive_rebounds + opponent_defensive_rebounds)
    end

    def team_total_rebound_percentage
      team_rebound_percentage(total_rebounds, team_total_rebounds + opponent_total_rebounds)
    end

    def rebound_percentage(rebounds, total_rebounds)
      begin
        (100 * (rebounds * (team_minutes / 5)) / (minutes.to_f * (total_rebounds))).round(2)
      rescue
        "div by 0"
      end
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
      ((field_goals_made + 0.5 * threes_made) / field_goals_attempted).round 3
    end

    def game_score
      (points + 0.4 * field_goals_made - 0.7 * field_goals_attempted - 0.4 * (free_throws_attempted - free_throws_made) + 0.7 * offensive_rebounds + 0.3 * defensive_rebounds + steals + 0.7 * assists + 0.7 * blocks - 0.4 * personal_fouls - turnovers).round 2
    end

    def unaveraged_possessions(fga, fta, o_rebounds, opp_d_rebounds, fg, tos)
      ((fga + 0.4 * fta - 1.07 * (o_rebounds.to_f / (o_rebounds + opp_d_rebounds)) * (fga - fg) + tos))
    end

    def team_possessions
      unaveraged_possessions(team_field_goals_attempted, team_free_throws_attempted, team_offensive_rebounds, opponent_defensive_rebounds, team_field_goals, team_turnovers)
    end

    def opponent_possessions
      unaveraged_possessions(opponent_field_goals_attempted, opponent_free_throws_attempted, opponent_offensive_rebounds, team_defensive_rebounds, opponent_field_goals_made, opponent_turnovers)
    end

    def possessions
      ((team_possessions + opponent_possessions) * 0.5)
    end

    def offensive_rating
      (points.to_f / possessions.to_f) * 100
    end

    def defensive_rating
      (opponent_score.to_f / possessions.to_f) * 100
    end

    def pace
      (48 * ((team_possessions + opponent_possessions) / (2 * (team_minutes / 5)))).round 2
    end

    def steal_percentage
      (100 * (steals * (team_minutes / 5)) / (minutes.to_f * possessions)).round 2
    end

    def team_steal_percentage
      (100 * (steals.to_f / possessions)).round 2
    end

    def turnover_percentage
      (100 * turnovers / (field_goals_attempted + 0.44 * free_throws_attempted + turnovers)).round 2
    end

    def true_shooting_percentage
      (points / (2 * true_shooting_attempts)).round 3
    end

    def true_shooting_attempts
      (field_goals_attempted + 0.44 * free_throws_attempted)
    end

    def usage
      (100 * ((field_goals_attempted + 0.44 * free_throws_attempted + turnovers) * (team_minutes / 5)) / (minutes * (team_field_goals_attempted + 0.44 * team_free_throws_attempted + team_turnovers))).round 2
    end
  end
end
