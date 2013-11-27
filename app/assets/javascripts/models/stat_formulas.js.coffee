class NbaOnePage.Models.StatFormulas
  assist_percentage: ->
    (100 * (@assists / (((@minutes / (@team_minutes / 5)) * @team_field_goals) - @made_field_goals)))

  team_assist_percentage: ->
    (100 * (@assists / @made_field_goals))

  block_percentage: ->
    (100 * (@blocks * (@team_minutes / 5)) / (@minutes * (@opponent_attempted_field_goals - @opponent_attempted_threes)))

  team_block_percentage: ->
    (100 * (@blocks / (@opponent_attempted_field_goals - @opponent_attempted_threes)))

  team_rebound_percentage: (rebounds, total_rebounds) ->
    @percentageRound(100 * (rebounds / total_rebounds))

  team_defensive_rebound_percentage: ->
    @team_rebound_percentage(@defensive_rebounds, @team_defensive_rebounds + @opponent_offensive_rebounds)

  team_offensive_rebound_percentage: ->
    @team_rebound_percentage(@offensive_rebounds, @team_offensive_rebounds + @opponent_defensive_rebounds)

  team_total_rebound_percentage: ->
    @team_rebound_percentage(@total_rebounds, @team_total_rebounds + @opponent_total_rebounds)

  rebound_percentage: (rebounds, total_rebounds) ->
    try
      @percentageRound(100 * (rebounds * (@team_minutes / 5)) / (@minutes * (total_rebounds)))
    catch error
      return "div by 0"

  defensive_rebound_percentage: ->
    @rebound_percentage(@defensive_rebounds, @team_defensive_rebounds + @opponent_offensive_rebounds)

  offensive_rebound_percentage: ->
    @rebound_percentage(@offensive_rebounds, @team_offensive_rebounds + @opponent_defensive_rebounds)

  total_rebound_percentage: ->
    @rebound_percentage(@total_rebounds, @team_total_rebounds + @opponent_total_rebounds)

  effective_field_goal_percentage: ->
    @percentageRound((@made_field_goals + 0.5 * @made_threes) / @attempted_field_goals)

  game_score: ->
    (@points +
      0.4 * @made_field_goals -
      0.7 * @attempted_field_goals -
      0.4 * (@attempted_free_throws - @made_free_throws) +
      0.7 * @offensive_rebounds +
      0.3 * @defensive_rebounds +
      @steals +
      0.7 * @assists +
      0.7 * @blocks -
      0.4 * @personal_fouls -
      @turnovers)

  unaveraged_possessions: (fga, fta, o_rebounds, opp_d_rebounds, fg, tos) ->
    ((fga + 0.4 * fta - 1.07 * (o_rebounds / (o_rebounds + opp_d_rebounds)) * (fga - fg) + tos))

  team_possessions: ->
    @unaveraged_possessions(@team_attempted_field_goals, @team_attempted_free_throws, @team_offensive_rebounds, @opponent_defensive_rebounds, @team_field_goals, @team_turnovers)

  opponent_possessions: ->
    @unaveraged_possessions(@opponent_attempted_field_goals, @opponent_attempted_free_throws, @opponent_offensive_rebounds, @team_defensive_rebounds, @opponent_made_field_goals, @opponent_turnovers)

  possessions: ->
    ((@team_possessions() + @opponent_possessions()) * 0.5)

  offensive_rating: ->
    ((@points / @possessions()) * 100)

  defensive_rating: ->
    ((@opponent_score / @possessions()) * 100)

  pace: ->
    (48 * ((@team_possessions() + @opponent_possessions()) / (2 * (@team_minutes / 5))))

  steal_percentage: ->
    @percentageRound(100 * (@steals * (@team_minutes / 5)) / (@minutes * @possessions()))

  team_steal_percentage: ->
    @percentageRound(100 * (@steals / @possessions()))

  turnover_percentage: ->
    @percentageRound(100 * @turnovers / (@attempted_field_goals + 0.44 * @attempted_free_throws + @turnovers))

  true_shooting_percentage: ->
    @percentageRound(@points / (2 * @true_shooting_attempts()))

  true_shooting_attempts: ->
    (@attempted_field_goals + 0.44 * @attempted_free_throws)

  usage: ->
    (100 * ((@attempted_field_goals + 0.44 * @attempted_free_throws + @turnovers) * (@team_minutes / 5)) / (@minutes * (@team_attempted_field_goals + 0.44 * @team_attempted_free_throws + @team_turnovers)))

  percentageRound: (value) ->
    Math.round(value * 1000) / 1000
