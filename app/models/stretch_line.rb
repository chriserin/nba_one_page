class StretchLine
  include Mongoid::Document
  include Mongoid::Timestamps
  include Nba::StatFormulas
  extend YearTypes

  field :team, type: String
  field :opponent, type: String
  field :team_players, type: Array
  field :opponent_players, type: Array
  field :game_date, type: DateTime
  field :start, type: Integer
  field :end, type: Integer

  (Nba::BaseStatistics).each do |stat_field|
    define_method "#{stat_field}_g" do
      (send(stat_field) / (attributes["games"] * 1.0)).round 2
    end

    define_method "#{stat_field}_36" do
      minutes = attributes["minutes"] / (is_subtotal ? 5.0 : 1.0)
      if minutes == 0
        "--"
      else
        (send(stat_field) * 36.0 / minutes).round 2
      end
    end
  end

  Nba::TalleableStatistics.each do |statistic|
    field statistic, type: Integer, default: 0
  end

  def self.collection_base_name
    "stretches"
  end
end
