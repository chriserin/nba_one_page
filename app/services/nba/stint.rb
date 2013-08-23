module Nba
  class Stint
    attr_accessor :start, :end
    def initialize(start=-1, stint_end=-1)
      @start = start
      @end = stint_end
    end
  end
end
