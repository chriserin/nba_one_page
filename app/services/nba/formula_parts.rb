module Nba
  FORMULA_PARTS = {
    :field_goal_percentage => [:field_goals_made, :field_goals_attempted],
    :free_throw_percentage => [:free_throws_made, :free_throws_attempted],
    :threes_percentage => [:threes_made, :threes_attempted],
    :assist_percentage => [:assists, :minutes, :team_minutes, :team_field_goals, :field_goals_made],
    :team_assist_percentage => [:assists, :team_field_goals, :field_goals_made],
    :block_percentage => [:blocks, :team_minutes, :minutes, :opponent_field_goals_attempted, :opponent_threes_attempted],
    :team_block_percentage => [:blocks, :opponent_field_goals_attempted, :opponent_threes_attempted],
    :steal_percentage => [:steals, :team_minutes, :minutes, :possessions],
    :team_steal_percentage => [:steals, :possessions],
    :defensive_rebound_percentage => [:defensive_rebounds, :team_defensive_rebounds, :opponent_offensive_rebounds, :team_minutes, :minutes],
    :offensive_rebound_percentage => [:offensive_rebounds, :team_offensive_rebounds, :opponent_defensive_rebounds, :team_minutes, :minutes],
    :total_rebound_percentage => [:total_rebounds, :team_total_rebounds, :opponent_total_rebounds, :team_minutes, :minutes],
    :team_defensive_rebound_percentage => [:defensive_rebounds, :team_defensive_rebounds, :opponent_offensive_rebounds],
    :team_offensive_rebound_percentage => [:offensive_rebounds, :team_offensive_rebounds, :opponent_defensive_rebounds],
    :team_total_rebound_percentage => [:total_rebounds, :team_total_rebounds, :opponent_total_rebounds],
    :effective_field_goal_percentage => [:field_goals_made, :threes_made, :field_goals_attempted],
    :game_score => [:points, :field_goals_made, :field_goals_attempted, :free_throws_attempted, :free_throws_made, :offensive_rebounds, :defensive_rebounds, :steals, :assists, :blocks, :personal_fouls, :turnovers],
    :turnover_percentage => [:turnovers, :field_goals_attempted, :free_throws_attempted],
    :true_shooting_percentage => [:points, :field_goals_attempted, :free_throws_attempted],
    :usage => [:field_goals_attempted, :free_throws_attempted, :turnovers, :team_minutes, :minutes, :team_field_goals_attempted, :team_free_throws_attempted, :team_turnovers],
    #:pace => [:pace]
  }
end
