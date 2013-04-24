module Nba
  module Roll
    class PerMinutesRolledDatum < RolledDatum

      def initialize(date, description, line, formula)
        @date, @start_date, @description, @formula = date, date, description, formula

        per_36_stat = formula[0..-4].to_sym
        @components = [per_36_stat, :minutes]

        set_base_data(@components, line)
      end

      #define per 36 minutes methods
      (Nba::BaseStatistics.minute_divisible_fields + %w{game_score}).each do |stat_field|
        define_method "#{stat_field}_36" do
          (@aggregated_values[stat_field.to_sym] * 36.0 / @aggregated_values[:minutes]).round 2
        end
      end
    end
  end
end
