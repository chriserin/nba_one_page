module Nba
  module Roll
    class RolledData
      def initialize(player, year, team)
        @player = player
        game_line_type = LineTypeFactory.get(year, :game_line)
        lines = game_line_type.any_of({"line_name" => player}, {"line_name" => team})
        @lines = @team_lines = lines.select { |line| line.line_name == player }
        @team_lines = lines.select { |line| line.line_name == team } if player != team
      end

      def roll_data(statistic, number_of_rolled_points)
        return [] if @lines.size == 0
        @rolled_datum_class = if statistic =~ /_36/
                                PerMinutesRolledDatum
                              elsif @player =~ /Difference/
                                DifferenceRolledDatum
                              else
                                RolledDatum
                              end

        @lines.sort_by! { |line| line.game_date }
        data = @lines.map { |line| @rolled_datum_class.new(line.game_date, "fake description", line, statistic) }

        results = data.each_with_index do |datum, index|
          data[[index - (number_of_rolled_points - 1), 0].max..index].each {|new_datum| datum.add_to_total(new_datum)}
        end

        (results + unplayed_results(results)).sort_by {|datum| datum.date}
      end

      def unplayed_results(results)
        unplayed_dates = @team_lines.reject {|g| results.detect { |r| g.game_date == r.date}}
        unplayed_results = unplayed_dates.map {|g| RolledDatum.new(g.game_date, g.game_text, g, nil)}
      end

      def inspect
        "lines #{@lines.count} team_lines #{@team_lines.count}"
      end
    end
  end
end
