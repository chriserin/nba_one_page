module ClassAccessors
  YEAR_TYPED_MODELS = %w{PlayModel GameLine DifferenceLine StretchLine ScheduledGame}

  YEAR_TYPED_MODELS.each do |model|
    define_method model do |date|
      season = ""
      if Nba::Calendar::SEASONS.keys.include?(date)
        season = date
      else
        season = Nba::Calendar.get_season(date)
      end
      self.class.const_get(__method__).make_year_type(season)
    end
  end
end

extend ClassAccessors
