module Nba
  TEAMS = {
    "New York Knicks"        => { :abbr => "NYK", :div => "atlantic",  :conference => "eastern", :nickname => "Knicks", :home_id => "18", :alt_abbr => "NY"},
    "Boston Celtics"         => { :abbr => "BOS", :div => "atlantic",  :conference => "eastern", :nickname => "Celtics", :home_id => "02"},
    "Dallas Mavericks"       => { :abbr => "DAL", :div => "southwest", :conference => "western", :nickname => "Mavericks", :home_id => "06"},
    "Miami Heat"             => { :abbr => "MIA", :div => "southeast", :conference => "eastern", :nickname => "Heat", :home_id => "14"},
    "Los Angeles Lakers"     => { :abbr => "LAL", :div => "pacific",   :conference => "western", :nickname => "Lakers", :home_id => "13"},
    "Chicago Bulls"          => { :abbr => "CHI", :div => "central",   :conference => "eastern", :nickname => "Bulls", :home_id => "04"},
    "Oklahoma City Thunder"  => { :abbr => "OKC", :div => "northwest", :conference => "western", :nickname => "Thunder", :home_id => "25"},
    "Orlando Magic"          => { :abbr => "ORL", :div => "southeast", :conference => "eastern", :nickname => "Magic", :home_id => "19"},
    "Golden State Warriors"  => { :abbr => "GSW", :div => "pacific",   :conference => "western", :nickname => "Warriors", :home_id => "09"},
    "Los Angeles Clippers"   => { :abbr => "LAC", :div => "pacific",   :conference => "western", :nickname => "Clippers", :home_id => "12"},
    "Cleveland Cavaliers"    => { :abbr => "CLE", :div => "central",   :conference => "eastern", :nickname => "Cavaliers", :home_id => "05"},
    "Toronto Raptors"        => { :abbr => "TOR", :div => "atlantic",  :conference => "eastern", :nickname => "Raptors", :home_id => "28"},
    "Indiana Pacers"         => { :abbr => "IND", :div => "central",   :conference => "eastern", :nickname => "Pacers", :home_id => "11"},
    "Detroit Pistons"        => { :abbr => "DET", :div => "central",   :conference => "eastern", :nickname => "Pistons", :home_id => "08"},
    "Houston Rockets"        => { :abbr => "HOU", :div => "southwest", :conference => "western", :nickname => "Rockets", :home_id => "10"},
    "Washington Wizards"     => { :abbr => "WAS", :div => "southeast", :conference => "eastern", :nickname => "Wizards", :home_id => "27"},
    "Brooklyn Nets"          => { :abbr => "BKN", :div => "atlantic",  :conference => "eastern", :nickname => "Nets", :home_id => "17"},
    "New Jersey Nets"        => { :abbr => "NJN", :div => "atlantic",  :conference => "eastern", :nickname => "Nets", :home_id => "17"},
    "Charlotte Bobcats"      => { :abbr => "CHA", :div => "southeast", :conference => "eastern", :nickname => "Bobcats", :home_id => "30"},
    "Milwaukee Bucks"        => { :abbr => "MIL", :div => "central",   :conference => "eastern", :nickname => "Bucks", :home_id => "15"},
    "Minnesota Timberwolves" => { :abbr => "MIN", :div => "northwest", :conference => "western", :nickname => "Timberwolves", :home_id => "16"},
    "Denver Nuggets"         => { :abbr => "DEN", :div => "northwest", :conference => "western", :nickname => "Nuggets", :home_id => "07"},
    "San Antonio Spurs"      => { :abbr => "SAS", :div => "southwest", :conference => "western", :nickname => "Spurs", :home_id => "24", :alt_abbr => "SA"},
    "Memphis Grizzlies"      => { :abbr => "MEM", :div => "southwest", :conference => "western", :nickname => "Grizzlies", :home_id => "29"},
    "Phoenix Suns"           => { :abbr => "PHX", :div => "pacific",   :conference => "western", :nickname => "Suns", :home_id => "21"},
    "New Orleans Hornets"    => { :abbr => "NOH", :div => "southwest", :conference => "western", :nickname => "Hornets", :home_id => "03", :alt_abbr => "NO"},
    "Portland Trail Blazers" => { :abbr => "POR", :div => "northwest", :conference => "western", :nickname => "Trail Blazers", :home_id => "22"},
    "Philadelphia 76ers"     => { :abbr => "PHI", :div => "atlantic",  :conference => "eastern", :nickname => "76ers", :home_id => "20"},
    "Sacramento Kings"       => { :abbr => "SAC", :div => "pacific",   :conference => "western", :nickname => "Kings", :home_id => "23"},
    "Atlanta Hawks"          => { :abbr => "ATL", :div => "southeast", :conference => "eastern", :nickname => "Hawks", :home_id => "01"},
    "Utah Jazz"              => { :abbr => "UTA", :div => "northwest", :conference => "western", :nickname => "Jazz", :home_id => "26"}
  }

  def TEAMS.find(team_fragment)
    self.keys.find { |key| key =~ /#{team_fragment}/}
  end

  def TEAMS.find_abbr(team_fragment)
    team_name = self.find(team_fragment)
    team = self[team_name]
    team[:abbr]
  end

  def TEAMS.find_alt_abbr(team_fragment)
    team_name = self.find(team_fragment)
    team = self[team_name]
    team[:alt_abbr] || team[:abbr]
  end

  def TEAMS.find_teamname_by_abbr(team_abbr)
    self.map {|key, value| return key if value[:abbr] == team_abbr.upcase}.compact.first
  end

  def TEAMS.find_teamname_by_alt_abbr(team_abbr)
    teamname = self.map {|key, value| return key if value[:alt_abbr] == team_abbr.upcase}.compact.first
    teamname || self.find_teamname_by_abbr(team_abbr)
  end
end
