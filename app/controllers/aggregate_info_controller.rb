class AggregateInfoController < ApplicationController
  caches_page :index

  def index
    team         = params[:team] || "Bulls"
    season       = Nba::Season.new "2012"
    @total_lines = season.total_statistics_for_team(team)
    @standings   = season.standings
    @schedule    = season.schedule(team)
    @boxscore    = season.boxscore(@schedule.date_of_last_game_played, team)
  end

  def boxscore
    team      = params[:team]
    date      = params[:date]
    game_date = Time.at(@date.to_i / 1000).utc().strftime("%Y-%m-%d")
    @boxscore = season.boxscore(team, @schedule.date_of_last_game_played)

    render :layout => false
  end

  def clear_cache
    expire_page action: :index
    render :nothing => true
  end
end
