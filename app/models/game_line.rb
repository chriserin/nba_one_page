class GameLine
  include Mongoid::Document

  field :line_name, type: String
  field :position, type: String
  field :team, type: String
  field :team_abbr, type: String
  field :team_division, type: String
  field :team_conference, type: String
  field :opponent, type: String
  field :opponent_abbr, type: String
  field :opponent_division, type: String
  field :opponent_conference, type: String
  field :game_date, type: String
  field :game_result, type: String
  field :starter, type: Boolean
  field :is_total, type: Boolean
  field :is_opponent_total, type: Boolean
  field :is_home, type: Boolean
  field :team_score, type: Integer
  field :opponent_score, type: Integer

  field :minutes, type: Integer, default: 0
  field :field_goals_made, type: Integer, default: 0
  field :field_goals_attempted, type: Integer, default: 0
  field :threes_made, type: Integer, default: 0
  field :threes_attempted, type: Integer, default: 0
  field :free_throws_made, type: Integer, default: 0
  field :free_throws_attempted, type: Integer, default: 0
  field :offensive_rebounds, type: Integer, default: 0
  field :defensive_rebounds, type: Integer, default: 0
  field :total_rebounds, type: Integer, default: 0
  field :assists, type: Integer, default: 0
  field :steals, type: Integer, default: 0
  field :blocks, type: Integer, default: 0
  field :turnovers, type: Integer, default: 0
  field :personal_fouls, type: Integer, default: 0
  field :plus_minus, type: Integer, default: 0
  field :points, type: Integer, default: 0

  def game_text
    if is_home
      "#{team_abbr} #{team_score} - #{opponent_abbr} #{opponent_score}"
    else
      "#{team_abbr} #{team_score} @ #{opponent_abbr} #{opponent_score}"
    end
  end

  def +(right_side_object)
    result = GameLine.new
    result[:line_name] = line_name
    result[:is_total] = self[:is_total]
    self.fields.select{|key, value| value.type == Integer }.keys.each do |field_name|
      result[field_name] = (self[field_name] || 0) + (right_side_object[field_name] || 0)
    end
    result
  end
end
