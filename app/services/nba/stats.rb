module Nba
  module Stats
    include ActiveSupport::Concern
    include Splits

    def stats(split_type=:all)
      TeamTotals.new(add_lines(data(split_type)))
    end

    def add_lines(lines)
      grouped = lines.group_by { |line| line.line_name }
      added   = grouped.values.map   { |lines| lines.inject(:+) }
    end
  end
end
