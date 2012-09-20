Factory.define :game_line do |f|
  f.game_date DateTime.now
  f.team      "Chicago Bulls"
end

Factory.define :scheduled_game do |f|
  f.game_date DateTime.now
  f.home_team      "Chicago Bulls"
  f.away_team      "Denver Nuggets"
end
