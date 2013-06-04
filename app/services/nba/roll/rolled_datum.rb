module Nba
  module Roll
    class RolledDatum
      include Nba::StatFormulas

      attr_accessor :date, :start_date, :data_divisor, :description, :averaged_data, :line
      attr_accessor :formula, :components
      attr_accessor :game_data

      def initialize(date, description, line, formula)
        @date, @start_date, @description, @formula = date, date, description, formula
        @line = line
        @game_data = calc_game_data(line, formula) if formula.present?

        if formula
          @components = Nba::FORMULA_PARTS[formula.to_sym]

          if @components == nil
            @formula = :rolling_average
            @components = [formula]
          end

          set_base_data(@components, line)
        else
          @averaged_data = nil
        end

      end

      def calc_game_data(line, formula)
        line.send(formula.to_s)
      end

      def add_to_total(new_datum)
        aggregate_data(new_datum)
        @start_date = @start_date < new_datum.date ? @start_date : new_datum.date
        @data_divisor ||= 0
        @data_divisor += 1

        @averaged_data = send(@formula.to_s)
        @averaged_data = nil if @averaged_data.class == String
        @averaged_data
      end

      def aggregate_data(new_datum)
        @aggregated_values ||= Hash.new(0)
        new_datum.components.each do |component|
          data_to_be_added = new_datum.get_component_value(component)
          @aggregated_values[component.to_sym] += data_to_be_added
        end
      end

      def rolling_average
        divide_by_games_played(send(@components.first))
      end

      def divide_by_games_played(value)
        (value / @data_divisor.to_f).round 2
      end

      def set_base_data(components, line)
        @component_values ||= {}
        components.each do |component|
          component_value = line.send(component)
          @component_values[component] = component_value
        end
      end

      def get_component_value(component)
        @component_values[component]
      end

      #redefine the attributes to draw data from the aggregated values hash
      (Nba::BaseStatistics - ["games_started"] + %w{offensive_rating defensive_rating pace}).each do |stat_field|
        define_method "#{stat_field}" do
          @aggregated_values[stat_field.to_sym]
        end
      end
    end
  end
end


