module Nba
  class DifferenceRolledDatum < RolledDatum
    include Difference

    def initialize(date, description, line, formula)
      super(date, description, line, formula)

      if line.is_difference_total
        @called_count = 0
        redefine_formulas
      end
    end

    def set_base_data(components, line)
      @component_values ||= {}
      components.each do |component|
        component_value = line.attributes[component.to_s]
        @component_values[component.to_sym] = component_value
      end
    end

    def aggregate_data(new_datum)
      @aggregated_values ||= Hash.new([0, 0])
      new_datum.components.each do |component|
        data_to_be_added = new_datum.get_component_value(component.to_sym)
        first_value  = @aggregated_values[component.to_sym].first + data_to_be_added.first
        second_value = @aggregated_values[component.to_sym].second + data_to_be_added.second
        @aggregated_values[component.to_sym] = [first_value, second_value]
      end
    end

    Nba::BaseStatistics.minute_divisible_fields.each do |stat_field|
      define_method "#{stat_field}" do
        if @components.count > 1
          result = @aggregated_values[stat_field.to_sym][@called_count % 2]
          return result
        else
          @aggregated_values[stat_field.to_sym].first - @aggregated_values[stat_field.to_sym].second
        end
      end
    end
  end
end
