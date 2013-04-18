require_relative 'boxscore'

class Scrape::Line

  NAME, MINUTES, FIELD_GOAL_INFO, THREES_INFO, FREE_THROWS_INFO, OFFENSIVE_REBOUNDS, DEFENSIVE_REBOUNDS, REBOUNDS, ASSISTS, STEALS, BLOCKS, TURNOVERS, PERSONAL_FOULS, PLUS_MINUS, POINTS = [*0..14]

  def initialize(line_data, boxscore)
    @line_data = line_data
    @boxscore = boxscore
    @model_mimic = {}
    mimic_general_info()
    mimic_line_info()
    mimic_statistical_info()
    mimic_team_totals()
  end

  def to_hash
    @model_mimic
  end

  private
  def mimic_general_info
    #same for all lines
    @model_mimic[:game_date]           = @boxscore.game_date
    @model_mimic[:team_minutes]        = @boxscore.team_minutes

    #values that switch based on which team the boxscore represents
    @model_mimic[:team]                = @boxscore.team
    @model_mimic[:team_division]       = @boxscore.team_division
    @model_mimic[:team_conference]     = @boxscore.team_conference
    @model_mimic[:opponent]            = @boxscore.opponent
    @model_mimic[:opponent_division]   = @boxscore.opponent_division
    @model_mimic[:opponent_conference] = @boxscore.opponent_conference
    @model_mimic[:team_score]          = @boxscore.team_score
    @model_mimic[:opponent_score]      = @boxscore.opponent_score
    @model_mimic[:game_result]         = @boxscore.game_result
    @model_mimic[:is_home]             = @boxscore.is_home?
  end

  def mimic_line_info
    @model_mimic[:games_started]         = games_started
    @model_mimic[:line_name]             = line_name
    @model_mimic[:position]              = position
  end

  def mimic_statistical_info
    @model_mimic[:minutes]               = @line_data[MINUTES]
    @model_mimic[:field_goals_made]      = field_goals_made
    @model_mimic[:field_goals_attempted] = field_goals_attempted
    @model_mimic[:threes_made]           = threes_made
    @model_mimic[:threes_attempted]      = threes_attempted
    @model_mimic[:free_throws_made]      = free_throws_made
    @model_mimic[:free_throws_attempted] = free_throws_attempted
    @model_mimic[:offensive_rebounds]    = @line_data[OFFENSIVE_REBOUNDS]
    @model_mimic[:defensive_rebounds]    = @line_data[DEFENSIVE_REBOUNDS]
    @model_mimic[:total_rebounds]        = @line_data[REBOUNDS]
    @model_mimic[:assists]               = @line_data[ASSISTS]
    @model_mimic[:steals]                = @line_data[STEALS]
    @model_mimic[:blocks]                = @line_data[BLOCKS]
    @model_mimic[:turnovers]             = turnovers
    @model_mimic[:personal_fouls]        = @line_data[PERSONAL_FOULS]
    @model_mimic[:plus_minus]            = plus_minus
    @model_mimic[:points]                = @line_data[POINTS]
  end

  def statistical_info_keys
    return [:minutes, :field_goals_made, :field_goals_attempted, :threes_made, :threes_attempted, :free_throws_made, :free_throws_attempted, :offensive_rebounds, :defensive_rebounds, :total_rebounds, :assists, :steals, :blocks, :turnovers, :personal_fouls, :plus_minus, :points]
  end

  def mimic_team_totals
    @model_mimic[:team_turnovers]                 = team_turnovers
    @model_mimic[:team_free_throws_attempted]     = team_free_throws_attempted
    @model_mimic[:team_field_goals_attempted]     = team_field_goals_attempted
    @model_mimic[:team_field_goals_made]          = team_field_goals
    @model_mimic[:team_defensive_rebounds]        = team_defensive_rebounds
    @model_mimic[:team_offensive_rebounds]        = team_offensive_rebounds
    @model_mimic[:team_total_rebounds]            = team_total_rebounds
    @model_mimic[:opponent_free_throws_attempted] = opponent_free_throws_attempted
    @model_mimic[:opponent_field_goals_made]      = opponent_field_goals_made
    @model_mimic[:opponent_field_goals_attempted] = opponent_field_goals_attempted
    @model_mimic[:opponent_threes_attempted]      = opponent_threes_attempted
    @model_mimic[:opponent_offensive_rebounds]    = opponent_offensive_rebounds
    @model_mimic[:opponent_defensive_rebounds]    = opponent_defensive_rebounds
    @model_mimic[:opponent_total_rebounds]        = opponent_total_rebounds
    @model_mimic[:opponent_turnovers]             = opponent_turnovers
  end

  %w(opponent_turnovers opponent_total_rebounds opponent_defensive_rebounds opponent_offensive_rebounds opponent_threes_attempted opponent_field_goals_attempted opponent_field_goals_made opponent_free_throws_attempted team_total_rebounds team_offensive_rebounds team_defensive_rebounds team_field_goals team_field_goals_attempted team_free_throws_attempted team_turnovers).each do |team_method|
    define_method team_method do
      @boxscore.send(team_method.to_sym)
    end
  end

  def games_started
    raise "abstract method"
  end

  def line_name
    raise "abstract method"
  end

  def turnovers
    raise "abstract method"
  end

  def plus_minus
    raise "abstract method"
  end

  def position
    @line_data[NAME] && @line_data[NAME].split(?,)[1]
  end

  def field_goals_made
    @line_data[FIELD_GOAL_INFO] && @line_data[FIELD_GOAL_INFO].split(?-)[0]
  end

  def field_goals_attempted
    @line_data[FIELD_GOAL_INFO] && @line_data[FIELD_GOAL_INFO].split(?-)[1]
  end

  def threes_made
    @line_data[THREES_INFO] && @line_data[THREES_INFO].split(?-)[0]
  end

  def threes_attempted
    @line_data[THREES_INFO] && @line_data[THREES_INFO].split(?-)[1]
  end

  def free_throws_made
    @line_data[FREE_THROWS_INFO] && @line_data[FREE_THROWS_INFO].split(?-)[0]
  end

  def free_throws_attempted
    @line_data[FREE_THROWS_INFO] && @line_data[FREE_THROWS_INFO].split(?-)[1]
  end
end

class Scrape::TotalLine < Scrape::Line
  def games_started
    nil
  end

  def line_name
    @boxscore.team
  end

  def turnovers
    @boxscore.team_turnovers
  end

  def plus_minus
    @boxscore.team_score - @boxscore.opponent_score
  end

  def team_free_throws_attempted
    free_throws_attempted
  end

  def team_field_goals_attempted
    field_goals_attempted
  end

  def team_field_goals
    field_goals_made
  end

  def team_defensive_rebounds
    @line_data[DEFENSIVE_REBOUNDS]
  end

  def team_offensive_rebounds
    @line_data[OFFENSIVE_REBOUNDS]
  end

  def team_total_rebounds
    @line_data[REBOUNDS]
  end
end

class Scrape::PlayerLine < Scrape::Line
  def games_started
    nil
  end

  def line_name
    @boxscore.team
  end

  def turnovers
    @line_data[TURNOVERS]
  end

  def plus_minus
    nil
  end

end

class Scrape::SectionLine < Scrape::Line
  def initialize(data, boxscore)
    data = aggregate_lines(data, boxscore)
    super
  end

  def games_started
    nil
  end

  def line_name
    raise "abstract method"
  end

  def turnovers
    nil
  end

  def plus_minus
    nil
  end

  def position
    ""
  end

  def mimic_statistical_info
    statistical_info_keys.each do |key|
      @model_mimic[key] = @line_data[key]
    end
  end

  private
  def aggregate_lines(data, boxscore)
    result = Hash.new {0}
    data.each do |line|
      player_line = Scrape::PlayerLine.new(line, boxscore).to_hash
      statistical_info_keys.each do |key|
        result[key] += player_line[key] if player_line[key]
      end
    end
    return result
  end
end

class Scrape::StartersLine < Scrape::SectionLine
  def line_name
    "#{@boxscore.team} Starters"
  end
end

class Scrape::BenchLine < Scrape::SectionLine
  def line_name
    "#{@boxscore.team} Bench"
  end
end

class Scrape::OpponentTotalLine < Scrape::Line
  def games_started
    nil
  end

  def line_name
    "#{@boxscore.team} Opponent"
  end

  def turnovers
    nil
  end

  def plus_minus
    nil
  end
end

class Scrape::DifferenceTotalLine < Scrape::Line
  def games_started
    nil
  end

  def line_name
    "#{@boxscore.team} Difference"
  end

  def turnovers
    nil
  end

  def plus_minus
    nil
  end
end
