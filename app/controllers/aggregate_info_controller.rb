class AggregateInfoController < ApplicationController
  caches_page :index

  def index
    @alternate_style = params[:alt]

    team = @team = params[:team] || "Bulls"
    year = @year = params[:year] || "2012"
    puts params
    puts @year
    puts params[:year]
    season       = Nba::Season.new(year)
    @total_lines = season.total_statistics_for_team(team)
    @standings   = season.standings
    @schedule    = season.schedule(team)
    @boxscore    = season.boxscore(@schedule.date_of_last_game_played, team)

    if @alternate_style
      render "aggregate_info_alt/index"
    end
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
