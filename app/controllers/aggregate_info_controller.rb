class AggregateInfoController < ApplicationController
  caches_page :index

  def index
    @alternate_style = params[:alt] || true

    team_param = params[:team] || "Bulls"
    @year = params[:year] || "2013"
    @team = Nba::TEAMS.keys.find { |key| key =~ /#{team_param}/ }

    season       = Nba::Season.new(@year)
    @total_lines = season.total_statistics_for_team(@team)
    @standings   = season.standings
    @schedule    = season.schedule(@team)
    @boxscore    = season.boxscore(@schedule.date_of_last_game_played, @team)
    @former_player_lines = season.total_statistics_for_former_players(@boxscore.team_lines.first.team)

  end

  def boxscore
    team      = params[:team]
    date      = params[:date]
    game_date = Time.at(@date.to_i / 1000).utc().strftime("%Y-%m-%d")
    @boxscore = season.boxscore(team, @schedule.date_of_last_game_played)

    render :layout => false
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
