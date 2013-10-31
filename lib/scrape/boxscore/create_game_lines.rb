module Scrape
  class CreateGameLines
    def self.act(converted_boxscore, game_info)
      line_type = GameLine.make_year_type(Nba::Calendar.get_season(game_info.game_date))
      total          = GameLine.create!(converted_boxscore.total.to_hash)
      opponent_total = GameLine.create!(converted_boxscore.opponent_total.to_hash)
      difference = total.create_difference(opponent_total).save!

      converted_boxscore.player_lines.each do |player_line|
        line_type.create!(player_line.to_hash) if player_line.did_player_play?
      end

      line_type.create!(converted_boxscore.starters_total.to_hash)
      line_type.create!(converted_boxscore.bench_total.to_hash)
    end
  end
end
