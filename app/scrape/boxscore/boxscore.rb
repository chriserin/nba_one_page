module Scrape; end

class Scrape::Boxscore
  attr_accessor :opponent_boxscore, :starter_lines, :reserve_lines, :totals_lines

  def initialize(data, game_info, is_home)
    @starter_lines = data[0]
    @reserve_lines = data[1]
    @totals_lines = data[2]
    @game_info = game_info
    @is_home = is_home
  end

  def team
    return @game_info.home_team if @is_home
    @game_info.away_team
  end

  def game_date
    @game_info.game_date.to_date.strftime("%Y-%m-%d")
  end

  def team_minutes
    240 + (@game_info.periods - 4) * 25
  end

  def team_division
    Nba::TEAMS[team] && Nba::TEAMS[team][:div]
  end

  def team_conference
    Nba::TEAMS[team] && Nba::TEAMS[team][:conference]
  end

  def opponent
    @opponent_boxscore.team
  end

  def opponent_division
    @opponent_boxscore.team_division
  end

  def opponent_conference
    @opponent_boxscore.team_conference
  end

  def team_score
    return @game_info.home_score if @is_home
    @game_info.away_score
  end

  def opponent_score
    @opponent_boxscore.team_score
  end

  def game_result
    return "W" if team_score > opponent_score
    return "L"
  end
  
  def is_home?
    @is_home
  end

  def team_turnovers
    return @game_info.home_turnovers if @is_home
    @game_info.away_turnovers
  end

  def opponent_turnovers
    return @game_info.away_turnovers if @is_home
    @game_info.home_turnovers
  end

  %w{team opponent}.each do |side|
    #define team total methods
    %w{total_rebounds defensive_rebounds offensive_rebounds attempted_threes attempted_field_goals made_field_goals attempted_free_throws}.each do |total_stat|
      define_method "#{side}_#{total_stat}" do
        if side == "team"
          team_line.to_hash[total_stat.to_sym]
        else
          opponent_line.to_hash[total_stat.to_sym]
        end
      end
    end
  end

  private
  def team_line
    return Scrape::ReferenceLine.new(@totals_lines[0], self)
  end

  def opponent_line
    return Scrape::ReferenceLine.new(opponent_boxscore.totals_lines[0], opponent_boxscore)
  end
end
