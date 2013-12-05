module Nba
  class Period
    def self.get(seconds_passed)
      return 1 + (seconds_passed / 720) if seconds_passed <= 2880
      return 5 + (seconds_passed - 2880) / 300
    end
  end
end
