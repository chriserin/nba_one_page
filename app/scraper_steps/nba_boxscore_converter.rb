class NbaBoxscoreConverter < ScraperStep

  def run(data, home_team, away_team, game_date, home_score, away_score)
    converter = Converter.new(data, home_team, away_team, game_date, home_score, away_score)
    converter.convert()
  end

  class Converter
    attr_accessor :data, :home_team, :away_team, :game_date, :home_score, :away_score

    AWAY_STARTERS, AWAY_BENCH, AWAY_TOTALS, HOME_STARTERS, HOME_BENCH, HOME_TOTALS = [*0..5]
    NAME, MINUTES, FIELD_GOAL_INFO, THREES_INFO, FREE_THROWS_INFO, OFFENSIVE_REBOUNDS, DEFENSIVE_REBOUNDS, REBOUNDS, ASSISTS, STEALS, BLOCKS, TURNOVERS, PERSONAL_FOULS, PLUS_MINUS, POINTS = [*0..14]

    def initialize(data, home_team, away_team, game_date, home_score, away_score)
      @data, @home_team, @away_team, @game_date, @home_score, @away_score = data, home_team, away_team, game_date, home_score, away_score
    end

    def convert
      (AWAY_STARTERS..HOME_TOTALS).each do |section|
        process_boxscore_section(section)
      end
    end

    def process_boxscore_section(section)
      if [HOME_STARTERS, HOME_BENCH, AWAY_STARTERS, AWAY_BENCH].include? section
        data[section].each {|line| process_boxscore_line(line, section) }
      else
        totals_array = data[section].first
        totals_array.unshift ""
        process_boxscore_line(totals_array, section)
      end
    end

    def process_boxscore_line(line, section)
      if line.length > 4
        game_line_properties = {}

        #game information
        game_line_properties[:team]                  = team = (is_home(section) ? home_team : away_team)
        unless Nba::TEAMS[team]; return; end;

        game_line_properties[:team_abbr]             = Nba::TEAMS[team][:abbr]
        game_line_properties[:team_division]         = Nba::TEAMS[team][:div]
        game_line_properties[:team_conference]       = Nba::TEAMS[team][:conference]
        game_line_properties[:game_date]             = game_date.to_date.strftime("%Y-%m-%d")
        game_line_properties[:game_result]           = get_result(section, home_score.to_i, away_score.to_i)
        game_line_properties[:is_total]              = (section == HOME_TOTALS or section == AWAY_TOTALS)
        game_line_properties[:is_opponent_total]     = false
        game_line_properties[:opponent]              = opp_team = (is_home(section) ? away_team : home_team)
        game_line_properties[:opponent_abbr]         = Nba::TEAMS[opp_team][:abbr]
        game_line_properties[:opponent_division]     = Nba::TEAMS[opp_team][:div]
        game_line_properties[:opponent_conference]   = Nba::TEAMS[team][:conference]
        game_line_properties[:is_home]               = (is_home(section))
        game_line_properties[:team_score]            = (is_home(section) ? home_score : away_score)
        game_line_properties[:opponent_score]        = (is_home(section) ? away_score : home_score)

        #player information
        game_line_properties[:starter]               = (section == HOME_STARTERS or section == AWAY_STARTERS)
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
        game_line_properties[:turnovers]             = line[TURNOVERS]
        game_line_properties[:personal_fouls]        = line[PERSONAL_FOULS]
        game_line_properties[:plus_minus]            = line[PLUS_MINUS]
        game_line_properties[:points]                = line[POINTS]

        GameLine.create!(game_line_properties)
        if section == HOME_TOTALS or section == AWAY_TOTALS
          game_line_properties[:line_name]         = get_name(away_team, home_team, section) + " Opponent"
          game_line_properties[:team]              = get_name(away_team, home_team, section)
          game_line_properties[:opponent]          = (is_home(section) ? home_team : away_team)
          game_line_properties[:game_result]       = get_result(section, away_score.to_i, home_score.to_i)
          game_line_properties[:is_opponent_total] = true
          GameLine.create!(game_line_properties)
        end
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
