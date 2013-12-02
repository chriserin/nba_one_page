
module Scrape
  class Error < StandardError
  end

  class LineupNotFullError < Scrape::Error
  end

  class TooManyTeamsError < Scrape::Error
  end

  class TooManyPlayersError < Scrape::Error
    attr_accessor :extra_name
    def initialize(message, extra_name)
      @extra_name = extra_name
      super(message)
    end
  end
end
