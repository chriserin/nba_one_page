module Nba
  def self.Calendar(year)
    Nba::Schedule::Calendar.new(year)
  end
end
