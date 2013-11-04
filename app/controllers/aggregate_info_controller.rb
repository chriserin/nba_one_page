class AggregateInfoController < ApplicationController
  caches_page :index, :team_info


  def team_info
    @alternate_style = params[:alt] || false

    team_param = params[:team] || "Bulls"
    @year = params[:year] || (Nba::Calendar.get_current_year)
    @team = Nba::TEAMS.find(team_param)

    if @team.blank?
      raise ActionController::RoutingError.new("#{team_param} Not Found")
    end

    season               = Nba::Season.new(@year)
    @total_lines         = season.total_statistics_for_team(@team)
    @team_rep            = Nba::Team.get(@team)
    @boxscore            = season.boxscore(@team_rep.last_game_played, @team)
  end

  def index
    date        = params[:date]
    date        = date.to_date if date
    @year       = params[:year] || (Nba::Calendar.get_current_year)

    @title      = "NBA"
    season      = Nba::Season.new(@year)
    @totals = season.totals
    @opponent_totals = season.opponent_totals
  end

  def stats
    team_param = params[:team] || "Bulls"
    @year = params[:year] || "2013"
    @team = Nba::TEAMS.find(team_param)
    @split_type = params[:split_type] || :all

    season = Nba::Season.new(@year)
    @lines = season.total_statistics_for_team(@team, @split_type.to_sym)
    render :layout => false
  end

  def boxscore
    team_param = params[:team] || "Bulls"
    @team = Nba::TEAMS.find(team_param.strip)
    date  = DateTime.parse(params[:date] || "20130101").strftime("%Y-%m-%d")
    @year = params[:year] || Nba::Calendar.get_season(date)

    season = Nba::Season.new(@year)
    @boxscore = season.boxscore(date || @schedule.last_game_played, @team)
    render :layout => false
  end

  def clear_cache
    files, count = PageCache::ClearCache.clear
    render :inline => "#{files.join("<br/>")}<br/>count: #{count}"
  end
end
