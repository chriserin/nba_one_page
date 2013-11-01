require_relative 'boxscore'

module Scrape
  class Line

    NAME, MINUTES, FIELD_GOAL_INFO, THREES_INFO, FREE_THROWS_INFO, OFFENSIVE_REBOUNDS, DEFENSIVE_REBOUNDS, REBOUNDS, ASSISTS, STEALS, BLOCKS, TURNOVERS, PERSONAL_FOULS, PLUS_MINUS, POINTS = [*0..14]

    def initialize(line_data, boxscore)
      @line_data = line_data
      @boxscore = boxscore
      @model_mimic = initialize_mimic()
      mimic()
    end

    def initialize_mimic()
      raise "abstract method"
    end

    def mimic()
      mimic_general_info(@boxscore)
      mimic_line_info()
      mimic_statistical_info()
      mimic_team_totals()
    end

    def to_hash
      @model_mimic
    end

    private
    def mimic_general_info(boxscore)
      #same for all lines
      @model_mimic[:game_date]           = boxscore.game_date
      @model_mimic[:team_minutes]        = boxscore.team_minutes

      #values that switch based on which team the boxscore represents
      @model_mimic[:team]                = boxscore.team
      @model_mimic[:team_division]       = boxscore.team_division
      @model_mimic[:team_conference]     = boxscore.team_conference
      @model_mimic[:opponent]            = boxscore.opponent
      @model_mimic[:opponent_division]   = boxscore.opponent_division
      @model_mimic[:opponent_conference] = boxscore.opponent_conference
      @model_mimic[:game_result]         = boxscore.game_result
      @model_mimic[:is_home]             = boxscore.is_home?
    end

    def mimic_line_info
      @model_mimic[:games_started]         = games_started
      @model_mimic[:line_name]             = line_name
      @model_mimic[:position]              = position
      @model_mimic[:team_score]          = @boxscore.team_score
      @model_mimic[:opponent_score]      = @boxscore.opponent_score
    end

    def mimic_statistical_info
      @model_mimic[:minutes]               = @line_data[MINUTES] || 0
      @model_mimic[:made_field_goals]      = made_field_goals
      @model_mimic[:attempted_field_goals] = attempted_field_goals
      @model_mimic[:made_threes]           = made_threes
      @model_mimic[:attempted_threes]      = attempted_threes
      @model_mimic[:made_free_throws]      = made_free_throws
      @model_mimic[:attempted_free_throws] = attempted_free_throws
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
      return [:minutes, :made_field_goals, :attempted_field_goals, :made_threes, :attempted_threes, :made_free_throws, :attempted_free_throws, :offensive_rebounds, :defensive_rebounds, :total_rebounds, :assists, :steals, :blocks, :turnovers, :personal_fouls, :plus_minus, :points]
    end

    def mimic_team_totals
      @model_mimic[:team_turnovers]                 = team_turnovers
      @model_mimic[:team_attempted_free_throws]     = team_attempted_free_throws
      @model_mimic[:team_attempted_field_goals]     = team_attempted_field_goals
      @model_mimic[:team_made_field_goals]          = team_made_field_goals
      @model_mimic[:team_defensive_rebounds]        = team_defensive_rebounds
      @model_mimic[:team_offensive_rebounds]        = team_offensive_rebounds
      @model_mimic[:team_total_rebounds]            = team_total_rebounds
      @model_mimic[:opponent_attempted_free_throws] = opponent_attempted_free_throws
      @model_mimic[:opponent_made_field_goals]      = opponent_made_field_goals
      @model_mimic[:opponent_attempted_field_goals] = opponent_attempted_field_goals
      @model_mimic[:opponent_attempted_threes]      = opponent_attempted_threes
      @model_mimic[:opponent_offensive_rebounds]    = opponent_offensive_rebounds
      @model_mimic[:opponent_defensive_rebounds]    = opponent_defensive_rebounds
      @model_mimic[:opponent_total_rebounds]        = opponent_total_rebounds
      @model_mimic[:opponent_turnovers]             = opponent_turnovers
    end

    %w(opponent_turnovers opponent_total_rebounds opponent_defensive_rebounds opponent_offensive_rebounds opponent_attempted_threes opponent_attempted_field_goals opponent_made_field_goals opponent_attempted_free_throws team_total_rebounds team_offensive_rebounds team_defensive_rebounds team_made_field_goals team_attempted_field_goals team_attempted_free_throws team_turnovers).each do |team_method|
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

    def made_field_goals
      @line_data[FIELD_GOAL_INFO] && @line_data[FIELD_GOAL_INFO].split(?-)[0]
    end

    def attempted_field_goals
      @line_data[FIELD_GOAL_INFO] && @line_data[FIELD_GOAL_INFO].split(?-)[1]
    end

    def made_threes
      @line_data[THREES_INFO] && @line_data[THREES_INFO].split(?-)[0]
    end

    def attempted_threes
      @line_data[THREES_INFO] && @line_data[THREES_INFO].split(?-)[1]
    end

    def made_free_throws
      @line_data[FREE_THROWS_INFO] && @line_data[FREE_THROWS_INFO].split(?-)[0]
    end

    def attempted_free_throws
      @line_data[FREE_THROWS_INFO] && @line_data[FREE_THROWS_INFO].split(?-)[1]
    end
  end

  class TotalLine < Line
    def initialize(line_data, boxscore)
      line_data = line_data.dup rescue []
      line_data.unshift("")
      super
    end

    def initialize_mimic
      {is_total: true, is_opponent_total: false, is_difference_total: false, is_subtotal: false}
    end

    def games_started
      0
    end

    def line_name
      @boxscore.team
    end

    def turnovers
      @boxscore.team_turnovers
    end

    def plus_minus
      ((@boxscore.team_score && @boxscore.team_score.to_i) || 0) -
        ((@boxscore.opponent_score && @boxscore.opponent_score.to_i) || 0)
    end

    def position
    end

    def team_attempted_free_throws
      attempted_free_throws
    end

    def team_attempted_field_goals
      attempted_field_goals
    end

    def team_made_field_goals
      made_field_goals
    end

    def team_attempted_threes
      attempted_threes
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

  class ReferenceLine < TotalLine
    def mimic()
      mimic_general_info(@boxscore)
      mimic_line_info()
      mimic_statistical_info()
    end

    def initialize_mimic
      {}
    end
  end

  class PlayerLine < Line
    def initialize(line_data, boxscore, is_starter)
      @is_starter = is_starter
      super(line_data, boxscore)
    end

    def initialize_mimic
      {is_total: false, is_opponent_total: false, is_difference_total: false, is_subtotal: false}
    end

    def games_started
      return 1 if @is_starter
      return 0
    end

    def line_name
      @line_data[NAME].split(?,)[0].gsub(".", "") if @line_data[NAME].present?
    end

    def turnovers
      @line_data[TURNOVERS]
    end

    def plus_minus
      @line_data[PLUS_MINUS]
    end

    def did_player_play?
      @line_data.size > 4
    end
  end

  class SectionLine < Line
    def initialize(data, boxscore)
      data = aggregate_lines(data, boxscore)
      super
    end

    def initialize_mimic
      {is_total: false, is_opponent_total: false, is_difference_total: false, is_subtotal: true}
    end

    def games_started
      0
    end

    def line_name
      raise "abstract method"
    end

    def turnovers
      @model_mimic[key] = @line_data[key]
    end

    def plus_minus
      0
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
        player_line = PlayerLine.new(line, boxscore, false).to_hash
        statistical_info_keys.each do |key|
          result[key] += player_line[key].to_i if player_line[key]
        end
      end
      return result
    end
  end

  class StartersLine < SectionLine
    def games_started
      1
    end

    def line_name
      "#{@boxscore.team} Starters"
    end
  end

  class BenchLine < SectionLine
    def line_name
      "#{@boxscore.team} Bench"
    end
  end

  class OpponentTotalLine < TotalLine

    def initialize_mimic
      {is_total: true, is_opponent_total: true, is_difference_total: false, is_subtotal: false}
    end

    def mimic()
      mimic_general_info(@boxscore.opponent_boxscore)
      mimic_line_info()
      mimic_statistical_info()
      mimic_team_totals()
    end

    def line_name
      "#{@boxscore.opponent} Opponent"
    end
  end

  class DifferenceTotalLine < Line

    def initialize_mimic
      {is_total: false, is_opponent_total: false, is_difference_total: true, is_subtotal: false}
    end

    def games_started
      0
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
end
