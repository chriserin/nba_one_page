
class Scrape::ConvertPlay
  def self.to_hash(play)
    result_hash = {}
    result_hash[:player_name] = play.player_name
    result_hash[:team] = play.team
    result_hash[:opponent] = play.opponent
    result_hash[:game_date] = play.game_date
    result_hash[:play_time] = play.seconds_passed
    result_hash[:description] = play.description
    result_hash[:team_score] = play.team_score
    result_hash[:opponent_score] = play.opponent_score
    result_hash[:score_difference] = play.score_difference
    result_hash[:original_description] = play.original_description

    Nba::TalleableStatistics.each do |statistic|
      method_name = "is_#{statistic.to_s.singularize}" 
      result_hash[method_name.to_sym] = play.send("#{method_name}?")
    end

    return result_hash
  end
end
