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
    classes += " b2b" if game.is_back_to_back?
    classes += " 4i5" if game.is_four_in_five?
    classes += " ob2b" if game.is_opponent_back_to_back?
    classes += " o4i5" if game.is_opponent_four_in_five?
    classes += " home-games-left" if !game.is_played? and game.is_home?
    classes += " away-games-left" if !game.is_played? and game.is_away?
    classes += " b2b-left" if !game.is_played? and game.is_back_to_back?
    classes += " ob2b-left" if !game.is_played? and game.is_opponent_back_to_back?
    classes += " easy" if !game.is_played? and game.difficulty.to_f < 5 and game.difficulty.present?
    classes += " medium" if !game.is_played? and game.difficulty.to_f >= 5 and game.difficulty.to_f < 7
    classes += " hard" if !game.is_played? and game.difficulty.to_f >= 7
    classes
  end
end
