module Nba
  module Splits
    SPLIT_TYPES = Nba::Calendar.month_syms + [:home, :away]

    def filtered_data(splits)
      splits = [splits].flatten
      splits &= SPLIT_TYPES #check that its a permitted split type.  gracefully return all if not.
      query = data
      splits.each do |split|
        query.send(split)
      end
      return query
    end
  end
end
