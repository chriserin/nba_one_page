class ScheduledGame
  include Mongoid::Document

  field :game_date, type: Date
  field :home_team, type: String
  field :away_team, type: String
  field :played, type: Boolean, :default => false
  field :parsed, type: Boolean, :default => false
end
