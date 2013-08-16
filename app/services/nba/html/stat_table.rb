module Nba
  module Html
    TABLE_STATS = YAML.load_file(File.join(__dir__, 'table_stats.yml'))

    class StatTable
      include StatFormattingHelper
      include NumbersHelper

      def self.render(lines, table_type=:boxscore)
        self.new(lines, table_type).output.html_safe
      end

      def self.render_headers(table_type=:boxscore)
        self.new([], table_type).headers.html_safe
      end

      def initialize(lines, table_type=:boxscore)
        @lines = lines
        @table_type = table_type
      end

      def output
        @output = "<table #{table_data_attributes()}>#{head()}#{body()}</table>"
      end

      def table_data_attributes
        if @table_type == :boxscore
          formatted_game_date = @lines.first.game_date.to_date.strftime("%Y%m%d")
          "data-game-date='#{formatted_game_date}'"
        else
          ""
        end
      end

      def head
        "<thead><tr>#{headers}</tr></thead>"
      end

      def headers
        "<th>player</th>" +
        table_stats.inject("") do |headers, (stat, stat_options)|
          headers += "<th #{header_class(stat_options)}>#{stat_options['label']}</th>"
        end
      end

      def header_class(stat_options)
        stat_options['header_class'] ? "class='#{stat_options['header_class']}'" : ""
      end

      def table_stats
        TABLE_STATS.select do |stat, stat_options|
          stat_options['table_types'] && stat_options['table_types'].include?(@table_type)
        end
      end

      def body
        "<tbody>#{rows}</tbody>"
      end

      def rows
        @lines.inject("") do |rows, line|
          rows += "<tr data-player='#{player_name(line)}' class='#{line_class(line)}'>#{cells(line)}</tr>"
        end
      end

      def line_class(line)
        class_str = ""
        if line.games_started == 1
          class_str += "starter "
        end
        if line.is_total or line.is_difference_total
          class_str += "total "
        end
        if line.is_subtotal
          class_str += "subtotal "
        end
        class_str
      end

      def cells(line)
        player_name_cell(line) +
        table_stats.inject("") do |cells, (stat, stat_options)|
          cells += "<td data-stat='#{stat}' class='#{stat_options['class']}'>#{cell_value(line, stat, stat_options)}</td>"
        end
      end

      def player_name(line)
        name = line.is_opponent_total ? line.opponent : line.line_name
      end

      def player_name_cell(line)
        "<td>#{player_name(line)}</td>"
      end

      def cell_value(line, stat, stat_options)
        value = line.send(stat)
        return format_percentage(value) if stat_options.fetch('display_type', :integer) == :percentage and not line.is_difference_total
        return "--" if line.is_difference_total and stat_options.fetch('blank_on_difference', false)
        return highlight_difference(value, stat_options.fetch('display_type', :integer)) if line.is_difference_total
        return value
      end
    end
  end
end
