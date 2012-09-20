class BoxscoreInterpreter

  TEAMS = {
    "New York Knicks" => { :abbr => "NYK", :div => "atlantic", :conference => "eastern" },
    "Boston Celtics" => { :abbr => "BOS", :div => "atlantic", :conference => "eastern" },
    "Dallas Mavericks" => { :abbr => "DAL", :div => "southwest", :conference => "western" },
    "Miami Heat" => { :abbr => "MIA", :div => "southeast", :conference => "eastern" },
    "Los Angeles Lakers" => { :abbr => "LAL", :div => "pacific", :conference => "western" },
    "Chicago Bulls" => { :abbr => "CHI", :div => "central", :conference => "eastern" },
    "Oklahoma City Thunder" => { :abbr => "OKC", :div => "northwest", :conference => "western" },
    "Orlando Magic" => { :abbr => "ORL", :div => "southeast", :conference => "eastern" },
    "Golden State Warriors" => { :abbr => "GSW", :div => "pacific", :conference => "western" },
    "Los Angeles Clippers" => { :abbr => "LAC", :div => "pacific", :conference => "western" },
    "Cleveland Cavaliers" => { :abbr => "CLE", :div => "central", :conference => "eastern" },
    "Toronto Raptors" => { :abbr => "TOR", :div => "atlantic", :conference => "eastern" },
    "Indiana Pacers" => { :abbr => "IND", :div => "central", :conference => "eastern" },
    "Detroit Pistons" => { :abbr => "DET", :div => "central", :conference => "eastern" },
    "Houston Rockets" => { :abbr => "HOU", :div => "southwest", :conference => "western" },
    "Washington Wizards" => { :abbr => "WAS", :div => "southeast", :conference => "eastern" },
    "New Jersey Nets" => { :abbr => "NJN", :div => "atlantic", :conference => "eastern" },
    "Charlotte Bobcats" => { :abbr => "CHA", :div => "southeast", :conference => "eastern" },
    "Milwaukee Bucks" => { :abbr => "MIL", :div => "central", :conference => "eastern" },
    "Minnesota Timberwolves" => { :abbr => "MIN", :div => "northwest", :conference => "western" },
    "Denver Nuggets" => { :abbr => "DEN", :div => "northwest", :conference => "western" },
    "San Antonio Spurs" => { :abbr => "SAN", :div => "southwest", :conference => "western" },
    "Memphis Grizzlies" => { :abbr => "MEM", :div => "southwest", :conference => "western" },
    "Phoenix Suns" => { :abbr => "PHX", :div => "pacific", :conference => "western" },
    "New Orleans Hornets" => { :abbr => "NOH", :div => "southwest", :conference => "western" },
    "Portland Trail Blazers" => { :abbr => "POR", :div => "northwest", :conference => "western" },
    "Philadelphia 76ers" => { :abbr => "PHI", :div => "atlantic", :conference => "eastern" },
    "Sacramento Kings" => { :abbr => "SAC", :div => "pacific", :conference => "western" },
    "Atlanta Hawks" => { :abbr => "ATL", :div => "southeast", :conference => "eastern" },
    "Utah Jazz" => { :abbr => "UTA", :div => "northwest", :conference => "western" }
  }

  AWAY_STARTERS, AWAY_BENCH, AWAY_TOTALS, HOME_STARTERS, HOME_BENCH, HOME_TOTALS = [*0..5]

  NAME, MINUTES, FIELD_GOAL_INFO, THREES_INFO, FREE_THROWS_INFO, OFFENSIVE_REBOUNDS, DEFENSIVE_REBOUNDS, REBOUNDS, ASSISTS, STEALS, BLOCKS, TURNOVERS, PERSONAL_FOULS, PLUS_MINUS, POINTS = [*0..14]

  def self.interpret_data(data, home_team, away_team, game_date, home_score, away_score)
    process_group(data, home_team, away_team, game_date, HOME_TOTALS, home_score, away_score)
    process_group(data, home_team, away_team, game_date, AWAY_TOTALS, home_score, away_score)
    process_group(data, home_team, away_team, game_date, HOME_STARTERS, home_score, away_score)
    process_group(data, home_team, away_team, game_date, HOME_BENCH, home_score, away_score)
    process_group(data, home_team, away_team, game_date, AWAY_STARTERS, home_score, away_score)
    process_group(data, home_team, away_team, game_date, AWAY_BENCH, home_score, away_score)
  end

  def self.process_group(data, home_team, away_team, game_date, group, home_score, away_score)

    process_line = Proc.new do |line|
      if line.length > 4
        game_line_properties = {}

        #game information
        game_line_properties[:team] = team = (is_home(group) ? home_team : away_team)
        unless TEAMS[team]; next; end;
        game_line_properties[:team_abbr] = TEAMS[team][:abbr]
        game_line_properties[:team_division] = TEAMS[team][:div]
        game_line_properties[:team_conference] = TEAMS[team][:conference]
        game_line_properties[:game_date] = game_date
        game_line_properties[:game_result] = get_result(group, home_score.to_i, away_score.to_i)
        game_line_properties[:is_total] = (group == HOME_TOTALS or group == AWAY_TOTALS)
        game_line_properties[:is_opponent_total] = false
        game_line_properties[:opponent] = opp_team = (is_home(group) ? away_team : home_team)
        game_line_properties[:opponent_abbr] =  TEAMS[opp_team][:abbr]
        game_line_properties[:opponent_division] =  TEAMS[opp_team][:div]
        game_line_properties[:opponent_conference] =  TEAMS[team][:conference]
        game_line_properties[:is_home] = (is_home(group))
        game_line_properties[:team_score] = (is_home(group) ? home_score : away_score)
        game_line_properties[:opponent_score] = (is_home(group) ? away_score : home_score)

        #player information
        game_line_properties[:starter] = (group == HOME_STARTERS or group == AWAY_STARTERS)
        game_line_properties[:line_name] = (line[NAME].present? ? line[NAME].split(',')[0] : get_name(home_team, away_team, group)).gsub(".", "")
        game_line_properties[:position] = line[NAME].split(',')[1]
        game_line_properties[:minutes] = line[MINUTES]
        game_line_properties[:field_goals_made] = line[FIELD_GOAL_INFO].split('-')[0]
        game_line_properties[:field_goals_attempted] = line[FIELD_GOAL_INFO].split('-')[1]
        game_line_properties[:threes_made] = line[THREES_INFO].split('-')[0]
        game_line_properties[:threes_attempted] = line[THREES_INFO].split('-')[1]
        game_line_properties[:free_throws_made] = line[FREE_THROWS_INFO].split('-')[0]
        game_line_properties[:free_throws_attempted] = line[FREE_THROWS_INFO].split('-')[1]
        game_line_properties[:offensive_rebounds] = line[OFFENSIVE_REBOUNDS]
        game_line_properties[:defensive_rebounds] = line[DEFENSIVE_REBOUNDS]
        game_line_properties[:total_rebounds] = line[REBOUNDS]
        game_line_properties[:assists] = line[ASSISTS]
        game_line_properties[:steals] = line[STEALS]
        game_line_properties[:blocks] = line[BLOCKS]
        game_line_properties[:turnovers] = line[TURNOVERS]
        game_line_properties[:personal_fouls] = line[PERSONAL_FOULS]
        game_line_properties[:plus_minus] = line[PLUS_MINUS]
        game_line_properties[:points] = line[POINTS]

        GameLine.create!(game_line_properties)
        if group == HOME_TOTALS or group == AWAY_TOTALS
          game_line_properties[:line_name] = self.get_name(away_team, home_team, group) + " Opponent"
          game_line_properties[:team] = self.get_name(away_team, home_team, group)
          game_line_properties[:opponent] = (is_home(group) ? home_team : away_team)
          game_line_properties[:game_result] = self.get_result(group, away_score.to_i, home_score.to_i)
          game_line_properties[:is_opponent_total] = true
          GameLine.create!(game_line_properties)
        end

      end
    end

    if [HOME_STARTERS, HOME_BENCH, AWAY_STARTERS, AWAY_BENCH].include? group
      data[group].each &process_line
    else
      totals_array = data[group].first
      totals_array.unshift ""
      process_line.call totals_array
    end

  end

  def self.get_result(group, home_score, away_score)
    if is_home(group)
      home_score > away_score ? "W" : "L"
    else
      home_score > away_score ? "L" : "W"
    end
  end

  def self.get_name(home_team, away_team, group)
    if group == HOME_TOTALS 
      home_team
    else
      away_team
    end
  end

  def self.is_home(group)
    [HOME_STARTERS, HOME_BENCH, HOME_TOTALS].include?(group)
  end
end
