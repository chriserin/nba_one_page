class RolledDataController < ApplicationController
  def show
    lines = GameLine.where("line_name" => params[:name])

    stat = params[:stat] || "points"

    raw_points = lines.map{ |game|
      [game.game_date.to_datetime.to_i * 1000, game.attributes[stat], game.game_text] # <----- POINT DEFINED!!!
    }.sort_by { |point| point.first }

    #10 day rolling avg for the stat
    rolled_points = []
    raw_points.each_with_index { |point, index|
      stat_total = raw_points[[index - 9, 0].max..index].inject(0) { |total, point| total + point.second}
      avg = stat_total / [10.0, index + 1.0].min
      rolled_points << [ point.first, avg, point.last]
    }

    all_game_points = GameLine.where("line_name" => lines.first.team).map { |game|
      [game.game_date.to_datetime.to_i * 1000, nil, game.game_text]
    }.sort_by { |point| point.first }

    all_game_points.reject! { |game_point|
      rolled_points.map {|rolled_point| rolled_point.first}.include? game_point.first
    }

    sorted_rolled_filled_points = (rolled_points + all_game_points).sort_by {|point| point.first}
    sorted_raw_points = (raw_points + all_game_points).sort_by {|point| point.first}

    respond_to do |format|
      format.json { render :json => { :rolled_points => sorted_rolled_filled_points, :raw_points => sorted_raw_points}}
    end

  end
end
