
module TrueFalseComparison
  def <=>(other)
    raise ArgumentError unless [TrueClass, FalseClass].include?(other.class)
    other ? (self ? 0 : -1) : (self ? 1 : 0)
  end
end

TrueClass.send(:include, TrueFalseComparison)
FalseClass.send(:include, TrueFalseComparison)

class GameLine
  include Mongoid::Document
  include Mongoid::Timestamps
  include Nba::StatFormulas

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
  field :is_total, type: Boolean
  field :is_subtotal, type: Boolean
  field :is_opponent_total, type: Boolean
  field :is_home, type: Boolean
  field :team_score, type: Integer
  field :opponent_score, type: Integer
  field :team_minutes, type: Integer

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

  field :team_turnovers, type: Integer, default: 0
  field :team_free_throws_attempted, type: Integer, default: 0
  field :team_field_goals_attempted, type: Integer, default: 0
  field :team_defensive_rebounds, type: Integer, default: 0
  field :team_offensive_rebounds, type: Integer, default: 0
  field :team_total_rebounds, type: Integer, default: 0
  field :team_field_goals, type: Integer, default: 0
  field :opponent_free_throws_attempted, type: Integer, default: 0
  field :opponent_field_goals_made, type: Integer, default: 0
  field :opponent_field_goals_attempted, type: Integer, default: 0
  field :opponent_threes_attempted, type: Integer, default: 0
  field :opponent_offensive_rebounds, type: Integer, default: 0
  field :opponent_defensive_rebounds, type: Integer, default: 0
  field :opponent_total_rebounds, type: Integer, default: 0
  field :opponent_turnovers, type: Integer, default: 0

  field :games, type: Integer, default: 1
  field :games_started, type: Integer, default: 0

  index({ line_name: 1 })
  index({ game_date: 1 })
  index({ team: 1 })

  attr_writer :topfive
  def topfive; @topfive || false; end

  scope :team_lines,      ->(team) { where(:team => /#{team}/) }
  scope :opponent_lines,  ->(team) { where(:opponent => /#{team}/) }
  scope :game_lines,      ->(game_date) { where(:game_date => game_date) }
  scope :totals,          where("is_total" => true, "is_opponent_total" => false)
  scope :win_loss_totals, totals
  scope :results,         totals
  scope :team_results,    ->(team) { where(:team => /#{team}/).totals }
  scope :matchup_lines,   ->(team) { any_of({:team => /#{team}/}, {:opponent => /#{team}/}) }
  scope :boxscore_lines,  ->(team, game_date) { matchup_lines(team).game_lines(game_date).boxscore_sort }
  scope :boxscore_sort,   order_by(:games_started => :desc, :is_total => :asc, :is_opponent_total => :asc, :is_subtotal => :asc, :minutes => :desc)
  scope :season2013,      where(:game_date.gt => "2012-10-29", :game_date.lt => "2013-08-01")

  def self.season(year)
    if year == "2013"
      season2013
    else
      scoped
    end
  end

  def self.team_boxscore_lines_sorted(team, game_date)
    team_lines(team).game_lines(game_date).boxscore_sort
  end

  def self.opponent_boxscore_lines_sorted(team, game_date)
    opponent_lines(team).game_lines(game_date).boxscore_sort
  end

#order_by(:games_started => :desc, :is_total => :asc, :is_opponent_total => :asc, :is_subtotal => :asc, :minutes => :desc)
  def self.statistic_total_lines(team)
    @total_lines = team_lines(team).group_by{ |line| line.line_name }.values.map{ |lines_array| lines_array.inject(:+) }
    @total_lines = @total_lines.sort_by { |line| line.games_started }.reverse
    @total_lines[0..5].each do |line|
      line.topfive = true unless line.is_subtotal
    end
    return @total_lines
  end

  def self.statistic_total_lines_former_players(team)
    former_players = Nba::FORMER_PLAYERS[team]
    @total_lines = self.in("line_name" => former_players).group_by{ |line| line.line_name }.values.map{ |lines_array| lines_array.inject(:+) }.sort_by { |total_line| total_line.minutes }.reverse
  end

  def game_text
    if is_home
      "#{team_abbr} #{team_score} - #{opponent_abbr} #{opponent_score}"
    else
      "#{team_abbr} #{team_score} @ #{opponent_abbr} #{opponent_score}"
    end
  end

  def line_name_or_nickname
    (is_subtotal or is_total) ? nickname : line_name
  end

  def nickname
    line_name.gsub(team, Nba::TEAMS[team][:nickname])
  end

  #overload addition operator to create totals lines
  def +(right_side_line)
    result = GameLine.new
    right_side_line = right_side_line || GameLine.new

    copy_fields(result, :line_name, :team, :is_total, :is_opponent_total, :is_subtotal)

    GameLine.statistic_fields.each do |statistic|
      result[statistic] = stat(statistic) + right_side_line.stat(statistic)
    end

    return result
  end

  def stat(statistic_name)
    self[statistic_name] || 0
  end

  def copy_fields(result, *fields)
    fields.each { |f| result[f] = self[f] }
  end

  def round(num)
    (num * 10).ceil / 10.0
  end

  def game_date_millis
    game_date.to_datetime.to_i * 1000
  end

  def self.statistic_fields
    self.fields.select{|key, value| value.type == Integer }.keys
  end

  (statistic_fields + [:game_score]).each do |stat_field|
    define_method "#{stat_field}_g" do
      round(send(stat_field) / (attributes["games"] * 1.0))
    end

    define_method "#{stat_field}_36" do
      minutes = attributes["minutes"] / (is_subtotal ? 5.0 : 1.0)
      if minutes == 0
        "--"
      else
        round(send(stat_field) * 36.0 / minutes)
      end
    end
  end
end
