require './app/scrape/boxscore/line'

class Scrape::ConvertDescriptiveBoxscore
  def self.into_lines(boxscore)
    converted_boxscore = Scrape::ConvertedBoxscore.new
    converted_boxscore.total            = create_team_total(boxscore)
    converted_boxscore.opponent_total   = create_opponent_total(boxscore)
    converted_boxscore.player_lines     = create_team_lines(boxscore)
    converted_boxscore.starters_total   = create_starters_total(boxscore)
    converted_boxscore.bench_total      = create_bench_total(boxscore)

    return converted_boxscore
  end

  private
  def self.create_team_total(boxscore)
    Scrape::TotalLine.new(boxscore.totals_lines[0], boxscore)
  end

  def self.create_opponent_total(boxscore)
    Scrape::OpponentTotalLine.new(boxscore.opponent_boxscore.totals_lines[0], boxscore.opponent_boxscore)
  end

  def self.create_team_lines(boxscore)
    results = []
    boxscore.starter_lines.each do |boxscore_line|
      results << Scrape::PlayerLine.new(boxscore_line, boxscore, true)
    end
    boxscore.reserve_lines.each do |boxscore_line|
      results << Scrape::PlayerLine.new(boxscore_line, boxscore, false)
    end
    return results
  end

  def self.create_starters_total(boxscore)
    Scrape::StartersLine.new(boxscore.starter_lines, boxscore)
  end

  def self.create_bench_total(boxscore)
    Scrape::BenchLine.new(boxscore.reserve_lines, boxscore)
  end
end

