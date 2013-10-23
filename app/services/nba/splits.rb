module Nba
  module Splits
    SPLIT_TYPES = [:november, :december, :january, :february, :march, :april, :home, :away]

    def data(splits)
      splits = [splits].flatten
      query = gtype.team_lines(name)
      splits.each do |split|
        query.send(split)
      end
      return query
    end
  end
end
