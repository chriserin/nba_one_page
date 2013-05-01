module Nba
  FORMULA_PARTS = {
    :field_goal_percentage => [:made_field_goals, :attempted_field_goals],
    :free_throw_percentage => [:made_free_throws, :attempted_free_throws],
    :threes_percentage => [:made_threes, :attempted_threes],
    :assist_percentage => [:assists, :minutes, :team_minutes, :team_field_goals, :made_field_goals],
    :team_assist_percentage => [:assists, :team_field_goals, :made_field_goals],
    :block_percentage => [:blocks, :team_minutes, :minutes, :opponent_attempted_field_goals, :opponent_attempted_threes],
    :team_block_percentage => [:blocks, :opponent_attempted_field_goals, :opponent_attempted_threes],
    :steal_percentage => [:steals, :team_minutes, :minutes, :possessions],
    :team_steal_percentage => [:steals, :possessions],
    :defensive_rebound_percentage => [:defensive_rebounds, :team_defensive_rebounds, :opponent_offensive_rebounds, :team_minutes, :minutes],
    :offensive_rebound_percentage => [:offensive_rebounds, :team_offensive_rebounds, :opponent_defensive_rebounds, :team_minutes, :minutes],
    :total_rebound_percentage => [:total_rebounds, :team_total_rebounds, :opponent_total_rebounds, :team_minutes, :minutes],
    :team_defensive_rebound_percentage => [:defensive_rebounds, :team_defensive_rebounds, :opponent_offensive_rebounds],
    :team_offensive_rebound_percentage => [:offensive_rebounds, :team_offensive_rebounds, :opponent_defensive_rebounds],
    :team_total_rebound_percentage => [:total_rebounds, :team_total_rebounds, :opponent_total_rebounds],
    :effective_field_goal_percentage => [:made_field_goals, :made_threes, :attempted_field_goals],
    :game_score => [:points, :made_field_goals, :attempted_field_goals, :attempted_free_throws, :made_free_throws, :offensive_rebounds, :defensive_rebounds, :steals, :assists, :blocks, :personal_fouls, :turnovers],
    :turnover_percentage => [:turnovers, :attempted_field_goals, :attempted_free_throws],
    :true_shooting_percentage => [:points, :attempted_field_goals, :attempted_free_throws],
    :usage => [:attempted_field_goals, :attempted_free_throws, :turnovers, :team_minutes, :minutes, :team_attempted_field_goals, :team_attempted_free_throws, :team_turnovers],
    #:pace => [:pace]
  }
end
