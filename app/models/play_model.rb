
class PlayModel
  include Mongoid::Document
  include Mongoid::Timestamps
  extend YearTypes

  field :player_name, type: String
  field :team, type: String
  field :opponent, type: String
  field :game_date, type: String
  field :play_time, type: Integer
  field :description, type: String
  field :team_score, type: Integer
  field :opponent_score, type: Integer
  field :score_difference, type: Integer
  field :original_description, type: String
  field :total_periods, type: Integer

  Nba::BaseStatistics.talleable_statistics.each do |statistic|
    field "is_#{statistic}", type: Boolean, default: false
  end

  index({ player_name: 1})
  index({ game_date: 1})

  def self.collection_base_name
    "plays"
  end
end
