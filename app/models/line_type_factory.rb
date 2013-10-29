class LineTypeFactory

  class << self
    def get_line_type(year, type)
      puts year
      LINE_TYPES[year][type]
    end
    alias :get :get_line_type

    def create_line_type(year, type=:game_line)
      line_type = Class.new

      line_type.send(:include, Mongoid::Document)
      line_type.send(:include, Mongoid::Timestamps)
      line_type.send(:include, Nba::StatFormulas)

      year_getter = <<-eos
        class_variable_set :@@year, year
        class << self
          def year
            @@year
          end
        end
      eos

      line_type.class_eval(year_getter)

      silence_warnings do #this block warns of const_set already having set consts
        case type
        when :game_line
          line_type.store_in :collection => "game_lines.#{year}"
          line_type.send(:include, GameModel)
          Object.const_set(:GameLine, line_type)
        when :difference
          line_type.store_in :collection => "game_lines.#{year}"
          line_type = Class.new line_type
          line_type.send(:include, GameModel)
          line_type.send(:include, DifferenceModel)
          Object.const_set(:DifferenceLine, line_type)
        when :on_court_stretch
          line_type.store_in :collection => "stretches.#{year}"
          line_type.send(:include, StretchModel)
          Object.const_set(:StretchLine, line_type)
        end
      end

      return line_type
    end
  end

  LINE_TYPES = {
     "2014" => {
      :game_line  => self.create_line_type("2014", :game_line),
      :difference => self.create_line_type("2014", :difference),
      :on_court_stretch => self.create_line_type("2014", :on_court_stretch)
    },
    "2013" => {
      :game_line  => self.create_line_type("2013", :game_line),
      :difference => self.create_line_type("2013", :difference),
      :on_court_stretch => self.create_line_type("2013", :on_court_stretch)
    }
  }
end
