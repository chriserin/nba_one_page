module Nba
  class TeamTotals < Array
    def initialize(lines)
      super(lines)
    end

    def totals
      select { |line| line.is_total }
    end

    def difference_totals
      select { |line| line.is_difference_total }
    end

    def bench_subtotal
      select { |line| line.is_subtotal && line.line_name =~ /Bench/ }
    end

    def starters_subtotal
      select { |line| line.is_subtotal && line.line_name =~ /Starters/ }
    end

    def topfive
      select { |line| line.topfive }.sort_by {|l| l.minutes}.reverse
    end

    def outside_topfive
      select {|line| !line.topfive && !line.is_total && !line.is_subtotal && !line.is_difference_total}.sort_by {|l| l.minutes }.reverse

    end
  end
end
