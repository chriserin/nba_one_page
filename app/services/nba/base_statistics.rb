module Nba

  BaseStatistics = [
    :team_score,
    :opponent_score,
    :team_minutes,
    :minutes,
    :made_field_goals,
    :attempted_field_goals,
    :made_threes,
    :attempted_threes,
    :made_free_throws,
    :attempted_free_throws,
    :offensive_rebounds,
    :defensive_rebounds,
    :total_rebounds,
    :assists,
    :steals,
    :blocks,
    :turnovers,
    :personal_fouls,
    :plus_minus,
    :points,
    :team_turnovers,
    :team_attempted_free_throws,
    :team_attempted_field_goals,
    :team_defensive_rebounds,
    :team_offensive_rebounds,
    :team_total_rebounds,
    :team_field_goals,
    :opponent_attempted_free_throws,
    :opponent_made_field_goals,
    :opponent_attempted_field_goals,
    :opponent_attempted_threes,
    :opponent_offensive_rebounds,
    :opponent_defensive_rebounds,
    :opponent_total_rebounds,
    :opponent_turnovers,
    :games,
    :games_started
  ]

  def BaseStatistics.minute_divisible_fields
    self - [:minutes, :games, :games_started]
  end

end
