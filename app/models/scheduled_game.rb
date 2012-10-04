class ScheduledGame
  include Mongoid::Document

  field :game_date, type: Date
  field :home_team, type: String
  field :away_team, type: String
  field :played, type: Boolean, :default => false
  field :parsed, type: Boolean, :default => false

  def self.next_game_for(team)
    games(team).first
  end

  def self.next_game_text_for(team)
    self.next_game_for(team).game_text_for(team)
  end

  def game_text_for(team)

    if team == home_team
      "#{game_date.strftime("%m/%d")} #{away_team}"
    else
      "#{game_data} @#{home_team}"
    end
  end

  def game_text
    "#{Nba::TEAMS[away_team][:abbr]} @ #{Nba::TEAMS[home_team][:abbr]}"
  end

  def game_result
    "fix me"
  end

  def game_date_millis
    game_date.to_datetime.to_i * 1000
  end

  def team
    home_team
  end

  scope :games,               ->(team) { any_of({home_team: /#{team}/}, {away_team: /#{team}/}) }
  scope :unplayed,            order_by(:game_date => :asc).where(parsed: false)
  scope :unplayed_team_games, ->(team) { games(team).unplayed }
end
