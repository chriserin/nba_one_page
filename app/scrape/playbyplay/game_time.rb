module Scrape
  class GameTime
    def initialize(quarter, time)
      @quarter = quarter
      @time = time
    end

    def total_seconds
      minutes, seconds = @time.split ?:
      minutes_elapsed  = 12 - (minutes.to_i + 1)
      seconds_elapsed  = 60 - seconds.to_i
      quarter_seconds  = (@quarter.to_i - 1) * 12 * 60
      return minutes_elapsed * 60 + seconds_elapsed + quarter_seconds
    end
  end
end
