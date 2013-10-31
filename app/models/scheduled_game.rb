class ScheduledGame
  include Mongoid::Document
  extend YearTypes

  field :game_date, type: Date
  field :home_team, type: String
  field :away_team, type: String
  field :played, type: Boolean, :default => false
  field :parsed, type: Boolean, :default => false

  scope :games,               ->(team) { any_of({home_team: /#{team}/}, {away_team: /#{team}/}) }
  scope :unplayed,            order_by(:game_date => :asc).where(:game_date.gte => DateTime.now)
  scope :unplayed_team_games, ->(team) { games(team).unplayed }

  def game_text_for(team)
    if team == home_team
      "v. #{Nba::TEAMS[away_team][:nickname]}"
    else
      "@ #{Nba::TEAMS[home_team][:nickname]}"
    end
  end

  def game_text
    "#{Nba::TEAMS[away_team][:abbr]} @ #{Nba::TEAMS[home_team][:abbr]}"
  end

  def game_date_millis
    game_date.to_datetime.to_i * 1000
  end

  def team
    home_team
  end

  def opponent_of(team_name)
    if(team_name =~ /#{home_team}/)
      away_team
    else
      home_team
    end
  end

  def self.collection_base_name
    "scheduled_games"
  end
end
