class GameLine
  include Mongoid::Document
  include Mongoid::Timestamps
  include Nba::StatFormulas
  include DisplayAttributes
  include Nba::GameLineDescriptor
  extend YearTypes

  field :line_name, type: String
  field :position, type: String
  field :team, type: String
  field :team_division, type: String
  field :team_conference, type: String
  field :opponent, type: String
  field :opponent_division, type: String
  field :opponent_conference, type: String
  field :game_date, type: String
  field :game_result, type: String
  field :is_total, type: Boolean
  field :is_subtotal, type: Boolean
  field :is_opponent_total, type: Boolean
  field :is_difference_total, type: Boolean, default: false
  field :is_home, type: Boolean

  Nba::BaseStatistics.each do |statistic|
    field statistic, type: Integer, default: 0
  end

  #override default of 0
  field :games, type: Integer, default: 1

  #indexes
  index({ line_name: 1 })
  index({ game_date: 1 })
  index({ team: 1 })
  index({ is_total: 1, is_opponent_total: -1, is_difference_total: -1})

  scope :team_lines,     ->(team)      { where(:team => team) }
  scope :opponent_lines, ->(team)      { where(:opponent => /#{team}/) }
  scope :game_lines,     ->(game_date) { where(:game_date => game_date) }
  scope :matchup_lines,  ->(team)      { any_of({:team => /#{team}/}, {:opponent => /#{team}/}) }
  scope :boxscore_lines, ->(team, game_date) { matchup_lines(team).game_lines(game_date).boxscore_sort }
  scope :date_range,     ->(first_date, last_date) { where(:game_date.gte => first_date, :game_date.lte => last_date)}

  # totals
  scope :totals,            where("is_total" => true,  "is_opponent_total" => false, "is_difference_total" => false)
  scope :opponent_totals,   where("is_total" => true,  "is_opponent_total" => true,  "is_difference_total" => false)
  scope :difference_totals, where("is_total" => false, "is_opponent_total" => false, "is_difference_total" => true)

  # sorts
  scope :boxscore_sort,     order_by(:games_started => :desc, :is_difference_total => :asc, :is_total => :asc, :is_opponent_total => :asc, :is_subtotal => :asc, :minutes => :desc)

  # splits
  scope :is_home, where("is_home" => true)
  scope :is_road, where("is_home" => false)

  #Nba::Calendar(year).months.each do |month|
  #  scope month.name, ->() { date_range(month.start, month.end) }
  #end

  (Nba::BaseStatistics + [:game_score]).each do |stat_field|
    define_method "#{stat_field}_g" do
      return "--" if send(stat_field).nil?
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

  #overload addition operator to create totals lines
  def +(right_side_line)
    result          = self.class.new
    right_side_line = right_side_line || self.class.new

    copy_fields(result, :line_name, :team, :is_total, :is_opponent_total, :is_subtotal)

    Nba::BaseStatistics.each do |statistic|
      result[statistic] = stat(statistic) + right_side_line.stat(statistic)
    end

    return result
  end

  def create_difference(right_side_line)
    result          = DifferenceLine.make_year_type(self.class.year).new
    right_side_line = right_side_line || self.class.new

    copy_fields(result, :line_name, :team, :is_total, :is_opponent_total, :is_subtotal, :game_date, :opponent)

    Nba::BaseStatistics.each do |statistic|
      result[statistic] = [stat(statistic), right_side_line.stat(statistic)]
    end

    result[:games]               = 1
    result[:is_difference_total] = true
    result[:is_total]            = false
    result[:line_name]          += " Difference"

    return result
  end

  def stat(statistic_name)
    self[statistic_name] || 0
  end

  def copy_fields(result, *fields)
    fields.each { |field| result[field] = self[field] }
  end

  def self.collection_base_name
    "game_lines"
  end

  def played?; true; end

  def is_away?; !is_home; end
end
