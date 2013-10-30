module Nba
  module LineType
    extend ActiveSupport::Concern

    module ClassMethods
      def set_year(year)
        @@year = year
        @@game_line_type = GameLine.make_year_type(@@year)
      end

      def game_line_type
        @@game_line_type
      end
    end

    def gtype
      self.class.game_line_type
    end
  end
end
