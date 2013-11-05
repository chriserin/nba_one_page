module Scrape
  class VerifyPlays
    def self.verify_saved_plays(saved_plays)
      team     = saved_plays.first.team
      opponent = saved_plays.first.opponent
      game_date = saved_plays.first.game_date

      verify_team_tallies(team, game_date)
      verify_team_tallies(opponent, game_date)
    end

    def self.verify_team_tallies(team, game_date)
      team_total = GameLine(game_date).where(line_name: team, is_total: true, game_date: game_date.to_date).first
      return unless team_total
      Nba::TalleableStatistics.each do |statistic|
        method_name = "is_#{statistic.to_s.singularize}"
        tally = PlayModel(game_date).where(team: team, game_date: game_date, "#{method_name}" => true).count
        File.open("playbyplay_errors_#{DateTime.now.strftime('%Y%m%d')}.txt", "a"){|f| f.write_line "results match for #{method_name}. #{team} on #{game_date} #{tally} #{team_total.send(statistic)}"} unless tally == team_total.send(statistic)
      end
    end
  end
end
