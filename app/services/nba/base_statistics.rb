module Nba

  BaseStatistics = [
    :team_score,
    :opponent_score,
    :team_minutes,
    :minutes,
    :field_goals_made,
    :field_goals_attempted,
    :threes_made,
    :threes_attempted,
    :free_throws_made,
    :free_throws_attempted,
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
    :team_free_throws_attempted,
    :team_field_goals_attempted,
    :team_defensive_rebounds,
    :team_offensive_rebounds,
    :team_total_rebounds,
    :team_field_goals,
    :opponent_free_throws_attempted,
    :opponent_field_goals_made,
    :opponent_field_goals_attempted,
    :opponent_threes_attempted,
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
