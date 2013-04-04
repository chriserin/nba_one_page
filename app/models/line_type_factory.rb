class LineTypeFactory

  class << self
    def get_line_type(year, type)
      @line_types[year][type]
    end
    alias :get :get_line_type

    def create_line_type(year, type=:game_line)
      line_type = Class.new

      line_type.send(:include, Mongoid::Document)
      line_type.send(:include, Mongoid::Timestamps)
      line_type.send(:include, Nba::StatFormulas)
      line_type.send(:include, GameModel)

      year_getter = <<-eos
        class_variable_set :@@year, year
        class << self
          def year
            @@year
          end
        end
      eos

      line_type.class_eval(year_getter)

      case type
      when :game_line
        line_type.store_in :collection => "game_lines.#{year}"
        Object.const_set(:GameLine, line_type)
      when :difference
        line_type.store_in :collection => "game_lines.#{year}"
        line_type = Class.new line_type
        line_type.send(:include, DifferenceModel)
        Object.const_set(:DifferenceLine, line_type)
      when :lineup
        line_type.store_in :collection => "lineups.#{year}"
        line_type.send(:include, LineupLine)
      end

      return line_type
    end
  end

  @line_types = {
    "2013" => {
      :game_line  => self.create_line_type("2013", :game_line),
      :difference => self.create_line_type("2013", :difference)
    },
    #"2012" => {
    #  :game_line  => self.create_line_type("2012", :game_line),
    #  :difference => self.create_line_type("2012", :difference)
    #}
  }
end
