class DifferenceLine < GameLine
  include Difference

  after_initialize do
    @called_count = 0
    redefine_formulas
  end

  Nba::BaseStatistics.minute_divisible_fields.each do |stat_field|
    field stat_field, type: Array

    define_method "#{stat_field}" do
      if caller.find { |s| s =~ /stat_formulas/ }
        result = attributes[stat_field.to_s][@called_count % 2]
        return result
      else
        attributes[stat_field.to_s].first - attributes[stat_field.to_s].second
      end
    end
  end

  def +(right_side_line)
    check_line(right_side_line)

    #year = Nba::Calendar.get_season(game_date)
    result            = DifferenceLine.new
    right_side_line ||= DifferenceLine.new

    result[:games] = stat(:games) + right_side_line.stat(:games)

    copy_fields(result, :line_name, :team, :is_total, :is_opponent_total, :is_subtotal, :is_difference_total)

    Nba::BaseStatistics.minute_divisible_fields.map(&:to_s).each do |statistic|
      result[statistic] = stat(statistic).first + right_side_line.stat(statistic).first, stat(statistic).second + right_side_line.stat(statistic).second
    end

    return result
  end

  def check_line(right_side_line)
    if not right_side_line.respond_to?(:is_difference?) #not right_side_line.kind_of? self.class
      throw Exception.new "cannot add #{right_side_line.class.name} to #{self.class}"
    end
  end

  def is_difference?
    true
  end
end
