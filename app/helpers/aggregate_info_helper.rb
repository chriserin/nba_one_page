module AggregateInfoHelper
  def abbr_replace(abbr)
    case abbr
    when "NOH" then "NOR"
    when "BKN" then "NJN"
    else
      abbr
    end
  end

  def brk_abbr_replace(abbr)
    if abbr == "BKN"
      "BRK"
    else
      abbr
    end
  end

  def breakdown_classes(game)
    classes = ""
    classes += " b2b" if @team_rep.is_back_to_back?(game)
    classes += " 4i5" if @team_rep.is_four_in_five?(game)
    classes += " ob2b" if game.opp_team.is_back_to_back?(game)
    classes += " o4i5" if game.opp_team.is_four_in_five?(game)
    classes += " home-games-left" if !game.played? and game.is_home?
    classes += " away-games-left" if !game.played? and game.is_away?
    classes += " b2b-left" if !game.played? and game.is_back_to_back?
    classes += " ob2b-left" if !game.played? and game.opp_team.is_back_to_back?
    classes += " easy" if !game.played? and game.difficulty.to_f < 5
    classes += " medium" if !game.played? and game.difficulty.to_f >= 5 and game.difficulty.to_f < 7
    classes += " hard" if !game.played? and game.difficulty.to_f >= 7
    classes
  end
end
