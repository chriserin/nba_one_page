class AggregateInfoController < ApplicationController
  caches_page :index, :team_info

  def team_info
    @alternate_style = params[:alt] || false

    team_param = params[:team] || "Bulls"
    @year = params[:year] || "2013"
    @team = Nba::TEAMS.keys.find { |key| key =~ /#{team_param}/ }
    if @team.blank?
      raise ActionController::RoutingError.new('Not Found')
    end

    season               = Nba::Season.new(@year)
    @total_lines         = season.total_statistics_for_team(@team)
    @standings           = season.standings
    @schedule            = season.schedule(@team, @standings)
    @boxscore            = season.boxscore(@schedule.played_games.last.game_date, @team)
    @former_player_lines = season.total_statistics_for_former_players(@boxscore.team_lines.first.team)
  end

  def index
    date        = params[:date]
    date        = date.to_date if date
    @year       = params[:year] || "2013"

    @title      = "index"
    season      = Nba::Season.new(@year)
    @standings  = season.standings
    @opponent_totals = GameLine.season(@year).opponent_totals.group_by { |line| line.team }.map { |team, lines| lines.inject(:+) }
  end

  def boxscore
    team      = params[:team]
    date      = params[:date]
    game_date = Time.at(@date.to_i / 1000).utc().strftime("%Y-%m-%d")
    @boxscore = season.boxscore(team, @schedule.date_of_last_game_played)

    render :layout => false
  end

  def all_boxscores
    date        = params[:date]
    date        = date.to_date if date
    @year       = params[:year] || "2013"

    @title      = "boxscores"
    season      = Nba::Season.new(@year)
    @boxscores  = season.all_yesterdays_boxscores(date)
    @standings  = season.standings
  end

  def clear_cache
    Dir.new("#{Rails.root}/public").each do |file|
      if (Nba::TEAMS.keys.any? {|team| team =~ /#{file.gsub(".html", "")}/ } and not (file == ".." or file == ".")) or file == "index.html"
        File.delete("#{Rails.root}/public/#{file}")
      end
    end
    render :nothing => true
  end
end
