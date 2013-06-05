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
      end
    end
  end
end
