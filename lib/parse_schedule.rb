schedule_path = Rails.root.join("schedule.txt")
File.open(schedule_path).each_line do |line|
  words = line.split(" ")
  date_str = words[1..3].join(" ")
  game_date = DateTime.parse(date_str)
  away_team, home_team = words[4..5]
  ScheduledGame.create!(:game_date => game_date, :away_team => away_team, :home_team => home_team)
end
