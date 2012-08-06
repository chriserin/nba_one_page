class AggregateInfoController < ApplicationController

  def index
    # group the lines by player and then total the grouped lines
    @total_lines = GameLine.where("team" => /Bulls/).group_by{ |line| line.line_name }.values.map{ |lines_array| lines_array.inject(:+) }
    @standings = Standings.get_standings
    @team = @standings.get_team("Chicago Bulls")
    @team_boxscore_lines = GameLine.where("team" => "Chicago Bulls", "game_date" => @team.get_last_game_date).desc(:starter).asc(:is_total).asc(:is_opponent_total).desc(:minutes)
    @opponent_boxscore_lines = GameLine.where("opponent" => "Chicago Bulls", "game_date" => @team.get_last_game_date).desc(:starter).asc(:is_total).asc(:is_opponent_total).desc(:minutes)
  end

  def boxscore
    @team = params[:team]
    @date = params[:date]
    game_date = Time.at(@date.to_i / 1000).utc().strftime("%Y-%m-%d")
    @team_boxscore_lines = GameLine.where("team" => @team, "game_date" => game_date).desc(:starter).asc(:is_total).asc(:is_opponent_total).desc(:minutes)
    @opponent_boxscore_lines = GameLine.where("opponent" => @team, "game_date" => game_date.to_s).desc(:starter).asc(:is_total).asc(:is_opponent_total).desc(:minutes)

    render 'boxscore', :layout => false
  end
end
