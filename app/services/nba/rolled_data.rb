module Nba
  class RolledData
    def initialize(player, year)
      @lines = GameLine.season(year).where("line_name" => player)
      @team_lines = GameLine.season(year).where("line_name" => @lines.first.team) if @lines.size > 0
    end

    def roll_data(statistic, days)
      return [] if @lines.size == 0
      data = @lines.map { |g| RolledDatum.new g.game_date, g.send(statistic), g.game_text }
      results = data.each_with_index {|datum, index| data[[index - (days - 1), 0].max..index].each {|new_datum| datum.add_to_total(new_datum.data_for_date)} }

      (results + unplayed_results(results)).sort_by {|datum| datum.date}
    end

    def unplayed_results(results)
      unplayed_dates = @team_lines.reject {|g| results.detect { |r| g.game_date == r.date}}
      unplayed_results = unplayed_dates.map {|g| RolledDatum.new g.game_date, nil, g.game_text }
    end
  end

  class RolledDatum
    attr_accessor :date, :data_for_date, :total_data, :data_divisor, :description, :averaged_data

    def initialize(date, data_for_date, description)
      @date, @data_for_date, @description = date, data_for_date, description
    end

    def add_to_total(new_data)
      @total_data ||= 0
      @total_data += new_data
      @data_divisor ||= 0
      @data_divisor += 1
      @averaged_data = (@total_data / @data_divisor.to_f).round 2
    end
  end
end
