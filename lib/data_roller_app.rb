class DataRollerApp < Sinatra::Base
  get "/rolled_data/:name/:stat/:year.json" do

    stat = params[:stat] || "points"
    year = params[:year] || "2013"
    team = params[:team] || (raise Exception.new("Team is required"))
    rolled_data = Nba::RolledData.new params[:name], year, team

    obj = rolled_data.roll_data(stat, 10)
    [
      200,
      {"Content-Type" => 'application/json'},
      [obj.to_json]
    ]
  end
end
