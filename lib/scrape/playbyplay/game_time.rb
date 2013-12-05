module Scrape
  class GameTime
    def initialize(quarter, time)
      @quarter = quarter.to_i
      @time = time
    end

    def total_seconds
      minutes, seconds = @time.split ?:
      minutes_elapsed  = 12 - (minutes.to_i + 1)
      seconds_elapsed  = 60 - seconds.to_i
      quarter_seconds = ([@quarter, 5].min - 1) * 12 * 60
      if @quarter > 4
        quarter_seconds += (@quarter - 5) * 5 * 60
        minutes_elapsed = 5 - (minutes.to_i + 1)
      end
      return minutes_elapsed * 60 + seconds_elapsed + quarter_seconds
    end
  end
end
