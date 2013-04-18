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

