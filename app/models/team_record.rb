class TeamRecord

  attr_accessor :team, :games, :wins, :losses, :win_pct, :games_back


  def initialize(team, games)
    self.team = team
    self.games = games.sort_by { |game| game.game_date }
    self.wins = games.count { |game| game.game_result == "W" }
    self.losses = games.count { |game| game.game_result == "L" }
    self.games_back = {}
  end

  def win_pct(last_number_of_games = nil)
    rec = record_last(last_number_of_games)
    (rec.first * 1.0 / (rec.inject(:+)))
  end

  def set_games_back(organization, first_place_record, last_number_of_games = nil)
    self.games_back["#{organization}-#{last_number_of_games || ""}"] = games_back_from(first_place_record, last_number_of_games)
  end

  def games_back_from(other_team_record, last_number_of_games)
    team_record = record_last(last_number_of_games)
    gb = (other_team_record.first - wins) * 0.5 + (losses - other_team_record.second) * 0.5
    (gb == 0 ? "--" : gb)
  end

  def record_last(games_number)
    latest_games = games.last(games_number || games.count)
    record(latest_games)
  end

  def record(games)
    wins = games.count{|game| game.game_result == "W" }
    losses = games.count{|game| game.game_result == "L" }
    [wins, losses]
  end

  def home_record
    record(home_games)
  end

  def away_record
    record(away_games)
  end

  def home_games
    games.select { |game| game.is_home }
  end

  def away_games
    games.select { |game| ! game.is_home }
  end

  def get_games_back(organization, games_number = nil)
    games_back["#{organization}-#{games_number || ""}"]
  end

  def streak
    latest_games = games.reverse
    latest_result = latest_games.first.game_result
    streak_number = latest_games.inject(0) do |total, game|
      break total unless game.game_result == latest_result
      total + 1
    end

    "#{streak_number} #{latest_result}"
  end

  def last_game_text
    games.last.game_text
  end

  def last_game_date
    games.last.game_date
  end

  def previous_game_text
    games[-2].game_text
  end

  def next_game_text
    ScheduledGame.next_game_text_for(team)
  end

  def team_abbr
    games.first.team_abbr
  end

  def in_organization(organization)
    games.first.team_division == organization or games.first.team_conference == organization
  end

  def inspect
   "#{to_s}"
  end
end
