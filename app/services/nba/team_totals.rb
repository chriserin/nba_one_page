module Nba
  class TeamTotals

    FILTERS = {
      starters_subtotal: proc { |line| line.is_subtotal && line.line_name =~ /Starters/ },
      bench_subtotal: proc { |line| line.is_subtotal && line.line_name =~ /Bench/ },
      totals: proc { |line| line.is_total },
      difference_totals: proc { |line| line.is_difference_total }
    }

    def initialize(lines)
      @lines = lines
    end

    def topfive
      sorted_player_lines.take(5).sort_by {|p| p.minutes }.reverse
    end

    def outside_topfive
      (sorted_player_lines[5..-1] || []).sort_by {|p| p.minutes }.reverse
    end

    def sorted_player_lines
      player_lines.sort_by {|p| p.games_started}.reverse
    end

    def player_lines
      FILTERS.values.inject(@lines || []) {|lines, p| lines.reject &p }
    end

    def method_missing(meth, *args, &block)
      @lines.select(&FILTERS.fetch(meth)).reverse
    end
  end
end
