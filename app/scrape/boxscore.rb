module Scrape; end

class Scrape::Boxscore
  attr_writer :opponent_boxscore

  def initialize(data, game_info, is_home)
    @starter_lines = data[0]
    @reserve_lines = data[1]
    @totals_lines = data[2]
    @game_info = game_info
    @is_home = is_home
  end
end

class Scrape::GameInfo < Struct.new(:home_team,
                                    :away_team,
                                    :game_date,
                                    :home_score,
                                    :away_score,
                                    :periods,
                                    :home_turnovers,
                                    :away_turnovers)
end

class Scrape::TransformData
  def self.into_descriptive_boxscore(data, *game_info_args)
    game_info = Scrape::GameInfo.new(*game_info_args)
    away_boxscore = Scrape::Boxscore.new(data[0..2], game_info, false)
    home_boxscore = Scrape::Boxscore.new(data[3..5], game_info, true)

    away_boxscore.opponent_boxscore = home_boxscore
    home_boxscore.opponent_boxscore = away_boxscore

    return away_boxscore, home_boxscore, game_info
  end
end

class Scrape::ConvertDescriptiveBoxscore
  def self.into_model_hashes(boxscore)
    converted_boxscore = Scrape::ConvertedBoxscore.new
    converted_boxscore.total            = create_team_total(boxscore)
    converted_boxscore.opponent_total   = create_opponent_total(boxscore)
    converted_boxscore.difference_total = create_difference_total(boxscore)
    converted_boxscore.player_lines     = create_team_lines(boxscore)

    return converted_boxscore
  end

  private
  def self.create_team_total(boxscore)
    {}
  end

  def self.create_opponent_total(boxscore)
    {}
  end

  def self.create_difference_total(boxscore)
    {}
  end

  def self.create_team_lines(boxscore)
    []
  end
end

class Scrape::ConvertedBoxscore < Struct.new(:total,
                                             :opponent_total,
                                             :difference_total,
                                             :player_lines)
end
