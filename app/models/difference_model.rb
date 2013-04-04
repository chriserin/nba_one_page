module DifferenceModel
  include Difference

  module ClassMethods
    def define_line

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
    end
  end

  def self.included(base)
    base.extend(ClassMethods)
    base.define_line
  end

  def +(right_side_line)
    check_line(right_side_line)

    result            = LineTypeFactory.get(self.class.year, :difference).new
    right_side_line ||= LineTypeFactory.get(self.class.year, :difference).new

    result[:games] = stat(:games) + right_side_line.stat(:games)

    copy_fields(result, :line_name, :team, :is_total, :is_opponent_total, :is_subtotal, :is_difference_total)

    Nba::BaseStatistics.minute_divisible_fields.map(&:to_s).each do |statistic|
      result[statistic] = stat(statistic).first + right_side_line.stat(statistic).first, stat(statistic).second + right_side_line.stat(statistic).second
    end

    return result
  end

  def check_line(right_side_line)
    throw Exception.new "cannot add game line to difference line" if not right_side_line.kind_of? self.class
  end
end
