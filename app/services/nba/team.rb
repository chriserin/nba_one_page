module Nba
  class Team
    include Record
    include Place
    include Nba::Rest
    include Opponents
    include Strength
    include Stats
    include LineType
    include PlayedWhereCounts
    include Difficulty
    include DifficultyCounts

    class << self
      def set_register(register)
        @@register = register
      end

      def get(name)
        @teams ||= Hash.new {|h, team| h[team] = Team.new(team); }
        @teams[name]
      end
    end

    attr_reader :name

    def games
      @@register.group(name).values
    end

    def played_games
      @@register.group(name).values.select {|g| g.played? }
    end

    def unplayed_games
      @@register.group(name).values.reject {|g| g.played? }
    end

    def days_register
      @@register.group(name)
    end

    def data
      gtype.team_lines(name)
    end

    private
    def initialize(name)
      @name = name
    end

    def method_missing(meth, *args, &block)
      attr = TEAMS[name][meth]
      if attr
        return attr
      else
        super(meth, *args, &block)
      end
    end
  end
end
