module Nba
  TEAMS = {
    "New York Knicks"        => { :abbr => "NYK", :div => "atlantic",  :conference => "eastern", :nickname => "Knicks" },
    "Boston Celtics"         => { :abbr => "BOS", :div => "atlantic",  :conference => "eastern", :nickname => "Celtics" },
    "Dallas Mavericks"       => { :abbr => "DAL", :div => "southwest", :conference => "western", :nickname => "Mavericks" },
    "Miami Heat"             => { :abbr => "MIA", :div => "southeast", :conference => "eastern", :nickname => "Heat" },
    "Los Angeles Lakers"     => { :abbr => "LAL", :div => "pacific",   :conference => "western", :nickname => "Lakers" },
    "Chicago Bulls"          => { :abbr => "CHI", :div => "central",   :conference => "eastern", :nickname => "Bulls" },
    "Oklahoma City Thunder"  => { :abbr => "OKC", :div => "northwest", :conference => "western", :nickname => "Thunder" },
    "Orlando Magic"          => { :abbr => "ORL", :div => "southeast", :conference => "eastern", :nickname => "Magic" },
    "Golden State Warriors"  => { :abbr => "GSW", :div => "pacific",   :conference => "western", :nickname => "Warriors" },
    "Los Angeles Clippers"   => { :abbr => "LAC", :div => "pacific",   :conference => "western", :nickname => "Clippers" },
    "Cleveland Cavaliers"    => { :abbr => "CLE", :div => "central",   :conference => "eastern", :nickname => "Cavaliers" },
    "Toronto Raptors"        => { :abbr => "TOR", :div => "atlantic",  :conference => "eastern", :nickname => "Raptors" },
    "Indiana Pacers"         => { :abbr => "IND", :div => "central",   :conference => "eastern", :nickname => "Pacers" },
    "Detroit Pistons"        => { :abbr => "DET", :div => "central",   :conference => "eastern", :nickname => "Pistons" },
    "Houston Rockets"        => { :abbr => "HOU", :div => "southwest", :conference => "western", :nickname => "Rockets" },
    "Washington Wizards"     => { :abbr => "WAS", :div => "southeast", :conference => "eastern", :nickname => "Wizards" },
    "Brooklyn Nets"          => { :abbr => "BKN", :div => "atlantic",  :conference => "eastern", :nickname => "Nets" },
    "New Jersey Nets"        => { :abbr => "NJN", :div => "atlantic",  :conference => "eastern", :nickname => "Nets" },
    "Charlotte Bobcats"      => { :abbr => "CHA", :div => "southeast", :conference => "eastern", :nickname => "Bobcats" },
    "Milwaukee Bucks"        => { :abbr => "MIL", :div => "central",   :conference => "eastern", :nickname => "Bucks" },
    "Minnesota Timberwolves" => { :abbr => "MIN", :div => "northwest", :conference => "western", :nickname => "Timberwolves" },
    "Denver Nuggets"         => { :abbr => "DEN", :div => "northwest", :conference => "western", :nickname => "Nuggets" },
    "San Antonio Spurs"      => { :abbr => "SAS", :div => "southwest", :conference => "western", :nickname => "Spurs" },
    "Memphis Grizzlies"      => { :abbr => "MEM", :div => "southwest", :conference => "western", :nickname => "Grizzlies" },
    "Phoenix Suns"           => { :abbr => "PHX", :div => "pacific",   :conference => "western", :nickname => "Suns" },
    "New Orleans Hornets"    => { :abbr => "NOH", :div => "southwest", :conference => "western", :nickname => "Hornets" },
    "Portland Trail Blazers" => { :abbr => "POR", :div => "northwest", :conference => "western", :nickname => "Trail Blazers" },
    "Philadelphia 76ers"     => { :abbr => "PHI", :div => "atlantic",  :conference => "eastern", :nickname => "76ers" },
    "Sacramento Kings"       => { :abbr => "SAC", :div => "pacific",   :conference => "western", :nickname => "Kings" },
    "Atlanta Hawks"          => { :abbr => "ATL", :div => "southeast", :conference => "eastern", :nickname => "Hawks" },
    "Utah Jazz"              => { :abbr => "UTA", :div => "northwest", :conference => "western", :nickname => "Jazz" }
  }

  def TEAMS.find(team_fragment)
    self.keys.find { |key| key =~ /#{team_fragment}/}
  end
end
