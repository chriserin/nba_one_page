module Nba
  module Splits
    SPLIT_TYPES = Nba::Schedule::Calendar.month_syms + [:home, :away]

    def data(splits)
      splits = [splits].flatten
      splits &= SPLIT_TYPES
      query = gtype.team_lines(name)
      splits.each do |split|
        query.send(split)
      end
      return query
    end
  end
end
