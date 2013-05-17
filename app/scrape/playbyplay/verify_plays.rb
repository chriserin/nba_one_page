module Scrape
  class VerifyPlays
    def self.verify_free_throws(plays)
      grouped_plays = plays.group_by {|play| play.seconds_passed}
      missing_plays = grouped_plays.map {|time, grouped_plays| find_missing_free_throw(grouped_plays)}.compact
      plays + missing_plays
    end

    def self.find_missing_free_throw(grouped_plays)
      first_free_throw = find_play_with_keyword(grouped_plays, "1 of 2")
      second_free_throw = find_play_with_keyword(grouped_plays, "2 of 2")
      if first_free_throw.present? and second_free_throw.blank?
        return first_free_throw.duplicate_with_new_description(first_free_throw.description.sub("1", "2"))
      end
    end

    def self.find_play_with_keyword(plays, keyword)
      plays.find {|play| play.description.include? keyword }
    end

    def self.verify_saved_plays(saved_plays)
      team     = saved_plays.first.team
      opponent = saved_plays.first.opponent
      game_date = saved_plays.first.game_date

      verify_team_tallies(team, game_date)
      verify_team_tallies(opponent, game_date)
    end

    def self.verify_team_tallies(team, game_date)
      LineTypeFactory
      team_total = GameLine.where(line_name: team, is_total: true, game_date: game_date.to_date).first
      return unless team_total
      Nba::TalleableStatistics.each do |statistic|
        method_name = "is_#{statistic.to_s.singularize}"
        tally = PlayModel.where(team: team, game_date: game_date, "#{method_name}" => true).count
        File.open("playbyplay_errors_#{DateTime.now.strftime('%Y%m%d')}.txt", "a"){|f| f << "results match for #{method_name}. #{team} on #{game_date} #{tally} #{team_total.send(statistic)}"} # unless tally == team_total.send(statistic)
      end
    end
  end
end
