module ScheduleParse
  TEAMS = {
    "New York" => "New York Knicks",
    "Boston" => "Boston Celtics",
    "Dallas" => "Dallas Mavericks",
    "Miami" => "Miami Heat",
    "L.A. Lakers" => "Los Angeles Lakers",
    "Chicago" => "Chicago Bulls",
    "Oklahoma City" => "Oklahoma City Thunder",
    "Orlando" => "Orlando Magic",
    "Golden State" => "Golden State Warriors",
    "L.A. Clippers" => "Los Angeles Clippers",
    "Cleveland" => "Cleveland Cavaliers",
    "Toronto" => "Toronto Raptors",
    "Indiana" => "Indiana Pacers",
    "Detroit" => "Detroit Pistons",
    "Houston" => "Houston Rockets",
    "Washington" => "Washington Wizards",
    "Brooklyn" => "Brooklyn Nets",
    "Charlotte" => "Charlotte Bobcats",
    "Milwaukee" => "Milwaukee Bucks",
    "Minnesota" => "Minnesota Timberwolves",
    "Denver" => "Denver Nuggets",
    "San Antonio" => "San Antonio Spurs",
    "Memphis" => "Memphis Grizzlies",
    "Phoenix" => "Phoenix Suns",
    "New Orleans" => "New Orleans Pelicans",
    "Portland" => "Portland Trail Blazers",
    "Philadelphia" => "Philadelphia 76ers",
    "Sacramento" => "Sacramento Kings",
    "Atlanta" => "Atlanta Hawks",
    "Utah" => "Utah Jazz"
  }

  def self.find_teams(line)
    teams = TEAMS.keys.select { |team| line.include? team }
    if line.index(teams[0]) < line.index(teams[1])
      [TEAMS[teams[0]], TEAMS[teams[1]]]
    else
      [TEAMS[teams[1]], TEAMS[teams[0]]]
    end
  end


  schedule_path = Rails.root.join("data", "schedule.txt")
  season = "2014"
  line_type = ScheduledGame.make_year_type(season)
  line_type.delete_all
  File.open(schedule_path).each_line do |line|
    words = line.split(" ")
    date_str = words[1..3].join(" ")
    game_date = DateTime.parse(date_str)
    away_team, home_team = find_teams(line)
    line_type.create!(:game_date => game_date, :away_team => away_team, :home_team => home_team)
  end
end
