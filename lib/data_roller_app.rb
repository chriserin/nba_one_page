require 'jbuilder'

class DataRollerApp < Sinatra::Base
  get "/rolled_data/:name/:stat/:year.json" do

    stat = params[:stat] || "points"
    year = params[:year] || "2013"
    team = params[:team] || (raise Exception.new("Team is required"))
    rolled_data = Nba::Roll::RolledData.new params[:name], year, team

    rolled_data_array = rolled_data.roll_data(stat, 10)
    [
      200,
      {"Content-Type" => 'application/json'},
      render_json(rolled_data_array)
    ]
  end

  def render_json(rolled_data_array)
    Jbuilder.encode do |json|
      json.array! rolled_data_array do |rolled_datum|
        exhibit = Nba::Roll::RolledDatumExhibit.new(rolled_datum)
        json.date             exhibit.date
        json.start_date       exhibit.start_date
        json.averaged_data    exhibit.averaged_data
        json.description      exhibit.html_description
        json.component_values exhibit.component_values
        json.formula          exhibit.formula
      end
    end
  end
end

class PlaybyplayApp < Sinatra::Base
  get "/playbyplay/:date/:name/:stat.json" do
    date = params[:date] || "2013-01-01"
    name = params[:name] || "Chicago Bulls"
    stat = params[:stat] || "made_field_goals"
    season = Nba::Calendar.get_season(date)

    Rails.logger.info("playbyplay date is #{date}")
    date_query = DateTime.parse(date).strftime("%Y-%m-%d")
    plays = PlayModel.where("player_name" => name, "game_date" => date_query, "is_#{stat.singularize}" => true)
    stretches = StretchLine.make_year_type(season).where(:team_players.in => [name], :game_date => DateTime.parse("2012-01-01"))
    stints = Nba::StretchesList.new(stretches).compress_stretches

    [
      200,
      {"Content-Type" => 'application/json'},
      render_json(plays, stints)
    ]
  end

  def render_json(plays, stints)
    Jbuilder.encode do |json|
      json.plays(plays) do |p|
        json.time p.play_time
        json.description p.description
      end
      json.stints(stints) do |s|
        json.start s.start
        json.end   s.end
      end
    end
  end
end
