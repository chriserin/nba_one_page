module DisplayAttributes
  def opponent_abbr
    Nba::TEAMS[opponent][:abbr]
  end

  def opponent_of(name="")
    opponent
  end

  def team_abbr
    Nba::TEAMS[team][:abbr]
  end

  def game_text
    delimiter = ( is_home ? "-" : "@" )
    "#{team_abbr} #{team_score} #{delimiter} #{opponent_abbr} #{opponent_score}"
  end

  def line_name_or_nickname
    (is_subtotal or is_total or is_difference_total) ? nickname : line_name
  end

  def result
    if team_score > opponent_score
      "W"
    else
      "L"
    end
  end

  def nickname
    line_name.gsub(team, Nba::TEAMS[team][:nickname])
  end
end
