
module Scrape
  class Error < StandardError
  end

  class LineupNotFullError < Scrape::Error
  end

  class TooManyTeamsError < Scrape::Error
  end
end
