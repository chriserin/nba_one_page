class NbaBoxscoreConverter < ScraperStep

  def run(data, home_team, away_team, game_date, home_score, away_score, periods, home_turnovers, away_turnovers)
    converter = Converter.new(data, home_team, away_team, game_date, home_score, away_score, periods, home_turnovers, away_turnovers)
    converter.convert()
    return true
  end

  class Converter
    attr_accessor :data, :home_team, :away_team, :game_date, :home_score, :away_score, :periods

    AWAY_STARTERS, AWAY_BENCH, AWAY_TOTALS, HOME_STARTERS, HOME_BENCH, HOME_TOTALS = [*0..5]
    HOME_OPPONENT_TOTALS, AWAY_OPPONENT_TOTALS = HOME_TOTALS + 5, AWAY_TOTALS + 5
    HOME_DIFFERENCE_TOTALS, AWAY_DIFFERENCE_TOTALS = HOME_OPPONENT_TOTALS + 1, AWAY_OPPONENT_TOTALS + 1
    NAME, MINUTES, FIELD_GOAL_INFO, THREES_INFO, FREE_THROWS_INFO, OFFENSIVE_REBOUNDS, DEFENSIVE_REBOUNDS, REBOUNDS, ASSISTS, STEALS, BLOCKS, TURNOVERS, PERSONAL_FOULS, PLUS_MINUS, POINTS = [*0..14]

    def initialize(data, home_team, away_team, game_date, home_score, away_score, periods, home_turnovers, away_turnovers)
      @data, @home_team, @away_team, @game_date, @home_score, @away_score, @periods, @home_turnovers, @away_turnovers = data, home_team, away_team, game_date, home_score, away_score, periods, home_turnovers, away_turnovers
      @totals = {}
    end

    def convert
      process_boxscore_section(HOME_TOTALS)
      process_boxscore_section(AWAY_TOTALS)
      @totals[HOME_TOTALS].update_attributes!(assign_opponent_totals({}, AWAY_TOTALS))
      @totals[AWAY_TOTALS].update_attributes!(assign_opponent_totals({}, HOME_TOTALS))
      @totals[HOME_OPPONENT_TOTALS].update_attributes!(assign_opponent_totals({}, AWAY_TOTALS))
      @totals[AWAY_OPPONENT_TOTALS].update_attributes!(assign_opponent_totals({}, HOME_TOTALS))

      create_difference_totals

      process_order = [HOME_BENCH, HOME_STARTERS, AWAY_BENCH, AWAY_STARTERS]
      process_order.each do |section|
        process_boxscore_section(section)
      end

    end

    def process_boxscore_section(section)
      if [HOME_STARTERS, HOME_BENCH, AWAY_STARTERS, AWAY_BENCH].include? section
        section_lines = data[section].map {|line| process_boxscore_line(line, section) }
        create_section_total(section_lines, section)
      else
        totals_array = data[section].first
        totals_array.unshift ""
        @totals[section] = process_boxscore_line(totals_array, section)
      end
    end

    def create_difference_totals
      @totals[HOME_DIFFERENCE_TOTALS] = @totals[HOME_TOTALS].create_difference(@totals[AWAY_TOTALS])
      @totals[HOME_DIFFERENCE_TOTALS].save!
      @totals[AWAY_DIFFERENCE_TOTALS] = @totals[AWAY_TOTALS].create_difference(@totals[HOME_TOTALS])
      @totals[AWAY_DIFFERENCE_TOTALS].save!
    end

    def process_boxscore_line(line, section)
      if line.length > 4
        game_line_properties = {}

        #game information
        game_line_properties[:team]                  = team = (is_home(section) ? home_team : away_team)
        unless Nba::TEAMS[team]; return; end;

        game_line_properties[:team_division]         = Nba::TEAMS[team][:div]
        game_line_properties[:team_conference]       = Nba::TEAMS[team][:conference]
        game_line_properties[:game_date]             = game_date.to_date.strftime("%Y-%m-%d")
        game_line_properties[:game_result]           = get_result(section, home_score.to_i, away_score.to_i)
        game_line_properties[:is_total]              = is_total = (section == HOME_TOTALS or section == AWAY_TOTALS)
        game_line_properties[:is_opponent_total]     = false
        game_line_properties[:opponent]              = opp_team = (is_home(section) ? away_team : home_team)
        game_line_properties[:opponent_division]     = Nba::TEAMS[opp_team][:div]
        game_line_properties[:opponent_conference]   = Nba::TEAMS[team][:conference]
        game_line_properties[:is_home]               = (is_home(section))
        game_line_properties[:team_score]            = (is_home(section) ? home_score : away_score)
        game_line_properties[:opponent_score]        = (is_home(section) ? away_score : home_score)
        game_line_properties[:team_minutes]          = 240 + (@periods - 4) * 25

        #player information
        game_line_properties[:games_started]         = (section == HOME_STARTERS or section == AWAY_STARTERS) ? 1 : 0
        game_line_properties[:line_name]             = (line[NAME].present? ? line[NAME].split(',')[0] : get_name(home_team, away_team, section)).gsub(".", "")
        game_line_properties[:position]              = line[NAME].split(',')[1]
        game_line_properties[:minutes]               = line[MINUTES]
        game_line_properties[:field_goals_made]      = line[FIELD_GOAL_INFO].split('-')[0]
        game_line_properties[:field_goals_attempted] = line[FIELD_GOAL_INFO].split('-')[1]
        game_line_properties[:threes_made]           = line[THREES_INFO].split('-')[0]
        game_line_properties[:threes_attempted]      = line[THREES_INFO].split('-')[1]
        game_line_properties[:free_throws_made]      = line[FREE_THROWS_INFO].split('-')[0]
        game_line_properties[:free_throws_attempted] = line[FREE_THROWS_INFO].split('-')[1]
        game_line_properties[:offensive_rebounds]    = line[OFFENSIVE_REBOUNDS]
        game_line_properties[:defensive_rebounds]    = line[DEFENSIVE_REBOUNDS]
        game_line_properties[:total_rebounds]        = line[REBOUNDS]
        game_line_properties[:assists]               = line[ASSISTS]
        game_line_properties[:steals]                = line[STEALS]
        game_line_properties[:blocks]                = line[BLOCKS]
        game_line_properties[:turnovers]             = (is_total ? (is_home(section) ? @home_turnovers : @away_turnovers) : line[TURNOVERS])
        game_line_properties[:personal_fouls]        = line[PERSONAL_FOULS]
        game_line_properties[:plus_minus]            = ( is_total ? (is_home(section) ? (@home_score.to_i - @away_score.to_i) : (@away_score.to_i - @home_score.to_i) ) : line[PLUS_MINUS])
        game_line_properties[:points]                = line[POINTS]

        if section == HOME_STARTERS or section == HOME_BENCH
          assign_opponent_totals(game_line_properties, AWAY_TOTALS)
        elsif section == AWAY_STARTERS or section == AWAY_BENCH
          assign_opponent_totals(game_line_properties, HOME_TOTALS)
        end

        result = LineTypeFactory.get_line_type("2013", :game_line).create!(game_line_properties)
        if section == HOME_TOTALS or section == AWAY_TOTALS
          game_line_properties[:line_name]         = get_name(away_team, home_team, section) + " Opponent"
          game_line_properties[:team]              = get_name(away_team, home_team, section)
          game_line_properties[:opponent]          = (is_home(section) ? home_team : away_team)
          game_line_properties[:game_result]       = get_result(section, away_score.to_i, home_score.to_i)
          game_line_properties[:is_opponent_total] = true
          @totals[section + 5] = LineTypeFactory.get_line_type("2013", :game_line).create!(game_line_properties)
        end

        if section == HOME_STARTERS or section == HOME_BENCH
          assign_opponent_totals(game_line_properties, AWAY_TOTALS)
        elsif section == AWAY_STARTERS or section == AWAY_BENCH
          assign_opponent_totals(game_line_properties, HOME_TOTALS)
        end
      end

      return result
    end

    def create_section_total(lines, section)
      sub_total = lines.inject(:+)
      sub_total.line_name = get_total_name(section)
      lines.first.copy_fields(sub_total, :team,
                                      :team_division,
                                      :team_conference,
                                      :opponent,
                                      :opponent_division,
                                      :opponent_conference,
                                      :game_date,
                                      :game_result,
                                      :games_started,
                                      :is_home,
                                      :team_score,
                                      :team_turnovers,
                                      :team_free_throws_attempted,
                                      :team_field_goals_attempted,
                                      :team_defensive_rebounds,
                                      :team_offensive_rebounds,
                                      :team_total_rebounds,
                                      :team_field_goals,
                                      :opponent_score,
                                      :opponent_free_throws_attempted,
                                      :opponent_field_goals_made,
                                      :opponent_field_goals_attempted,
                                      :opponent_threes_attempted,
                                      :opponent_offensive_rebounds,
                                      :opponent_defensive_rebounds,
                                      :opponent_total_rebounds,
                                      :opponent_turnovers)
      sub_total.plus_minus = 0
      sub_total.games = 1
      sub_total.is_subtotal = true
      sub_total.save!
    end

    def get_total_name(section)
      if section == HOME_STARTERS
        "#{@home_team} Starters"
      elsif section == HOME_BENCH
        "#{@home_team} Bench"
      elsif section == AWAY_STARTERS
        "#{@away_team} Starters"
      elsif section == AWAY_BENCH
        "#{@away_team} Bench"
      end
    end

    def assign_opponent_totals(game_line_properties = {}, totals_section)

      game_line_properties[:team_turnovers]                 = opposite_section(totals_section).turnovers
      game_line_properties[:team_free_throws_attempted]     = opposite_section(totals_section).free_throws_attempted
      game_line_properties[:team_field_goals_attempted]     = opposite_section(totals_section).field_goals_attempted
      game_line_properties[:team_field_goals]               = opposite_section(totals_section).field_goals_made
      game_line_properties[:team_defensive_rebounds]        = opposite_section(totals_section).defensive_rebounds
      game_line_properties[:team_offensive_rebounds]        = opposite_section(totals_section).offensive_rebounds
      game_line_properties[:team_total_rebounds]            = opposite_section(totals_section).total_rebounds
      game_line_properties[:opponent_free_throws_attempted] = @totals[totals_section].free_throws_attempted
      game_line_properties[:opponent_field_goals_made]      = @totals[totals_section].field_goals_made
      game_line_properties[:opponent_field_goals_attempted] = @totals[totals_section].field_goals_attempted
      game_line_properties[:opponent_threes_attempted]      = @totals[totals_section].threes_attempted
      game_line_properties[:opponent_offensive_rebounds]    = @totals[totals_section].offensive_rebounds
      game_line_properties[:opponent_defensive_rebounds]    = @totals[totals_section].defensive_rebounds
      game_line_properties[:opponent_total_rebounds]        = @totals[totals_section].total_rebounds
      game_line_properties[:opponent_turnovers]             = @totals[totals_section].turnovers
      return game_line_properties
    end

    def opposite_section(totals_section)
      if totals_section == HOME_TOTALS
        @totals[AWAY_TOTALS]
      elsif totals_section == AWAY_TOTALS
        @totals[HOME_TOTALS]
      end
    end

    def get_result(section, home_score, away_score)
      if is_home(section)
        home_score > away_score ? "W" : "L"
      else
        home_score > away_score ? "L" : "W"
      end
    end

    def get_name(home_team, away_team, section)
      if section == HOME_TOTALS 
        home_team
      else
        away_team
      end
    end

    def is_home(section)
      [HOME_STARTERS, HOME_BENCH, HOME_TOTALS].include?(section)
    end
  end
end
