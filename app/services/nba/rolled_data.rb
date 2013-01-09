module Nba
  class RolledData
    def initialize(player, year)
      @lines = GameLine.season(year).where("line_name" => player)
      @team_lines = GameLine.season(year).where("line_name" => @lines.first.team) if @lines.size > 0
    end

    def roll_data(statistic, days)
      return [] if @lines.size == 0
      data = @lines.map { |g| RolledDatum.new(g.game_date, g.game_text, g, statistic) }
      results = data.each_with_index do |datum, index| 
        data[[index - (days - 1), 0].max..index].each {|new_datum| datum.add_to_total(new_datum)}
      end

      (results + unplayed_results(results)).sort_by {|datum| datum.date}
    end

    def unplayed_results(results)
      unplayed_dates = @team_lines.reject {|g| results.detect { |r| g.game_date == r.date}}
      unplayed_results = unplayed_dates.map {|g| RolledDatum.new(g.game_date, g.game_text, g, nil)}
    end
  end

  class RolledDatum
    include Nba::StatFormulas
    include Difference

    attr_accessor :date, :start_date, :data_for_date, :total_data, :data_divisor, :description, :averaged_data
    attr_accessor :formula, :components

    def initialize(date, description, line, formula)
      @date, @data_for_date, @description = date, data_for_date, description
      @formula = formula
      if formula
        if formula =~ /_36/
          per_36_stat = formula[0..-4].to_sym
          @components = [formula[0..-4].to_sym, :minutes]
          define_36_method(per_36_stat)
          set_data(components, line)
        else
          @components = Nba::FORMULA_PARTS[formula.to_sym]
          @formula = :rolling_average if @components == nil
          @components = [formula] if @components == nil
          set_data(components, line)
        end
      else
        @averaged_data = nil
      end
      @start_date = @date
      if line.is_difference_total
        @called_count = 0
        redefine_formulas
      end
    end

    def add_to_total(new_datum)
      aggregate_data(new_datum)
      @start_date = @start_date < new_datum.date ? @start_date : new_datum.date
      @data_divisor ||= 0
      @data_divisor += 1
      if @formula != "game_score"
        @averaged_data = send(@formula)
        if @averaged_data.class == String
          @averaged_data = nil
        end
      else
        @averaged_data = divide_by_games_played(send(@formula))
      end
    end

    def rolling_average
      divide_by_games_played(send(@components.first))
    end

    def divide_by_games_played(value)
      (value / @data_divisor.to_f).round 2
    end

    def set_data(components, line)
      components.each do |component|
        component_value = line.send(component)
        component_value = line.attributes[component.to_s] if components.count > 1 and component != :game_score
        instance_eval("@#{component} = #{component_value}; def #{component}_c(); @#{component}; end")
      end
    end

    def aggregate_data(new_datum)
      new_datum.components.each do |component|
        data_to_be_added = new_datum.send(component.to_s + "_c")
        if data_to_be_added.class == Array and new_datum.components.size > 1
          instance_eval("@#{component}_agg ||= [0, 0]")
          instance_eval("@#{component}_agg = @#{component}_agg.first + #{data_to_be_added.first}, @#{component}_agg.second + #{data_to_be_added.second}")
          instance_eval("def #{component}(); @#{component}_agg[@called_count % 2]; end")
        else
          instance_eval("@#{component}_agg ||= 0")
          instance_eval("@#{component}_agg += #{data_to_be_added}")
          instance_eval("def #{component}(); @#{component}_agg; end")
        end
      end
    end

    def define_36_method(stat_field)
      singleton_class.class_eval {
        define_method "#{stat_field}_36" do
          if minutes == 0
            "--"
          else
            (send(stat_field) * 36.0 / minutes).round 2
          end
        end
      }
    end
  end
end
