module Scrape
  class CreateGameLines
    def self.act(converted_boxscore)
      LineTypeFactory.get("2013", :game_line)
      total          = GameLine.create!(converted_boxscore.total.to_hash)
      opponent_total = GameLine.create!(converted_boxscore.opponent_total.to_hash)
      difference = total.create_difference(opponent_total).save!

      converted_boxscore.player_lines.each do |player_line|
        GameLine.create!(player_line.to_hash) if player_line.did_player_play?
      end

      GameLine.create!(converted_boxscore.starters_total.to_hash)
      GameLine.create!(converted_boxscore.bench_total.to_hash)
    end
  end
end
