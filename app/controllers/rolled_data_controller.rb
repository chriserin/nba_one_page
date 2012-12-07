class RolledDataController < ApplicationController
  def show

    stat = params[:stat] || "points"
    year = params[:year] || "2013"
    rolled_data = Nba::RolledData.new params[:name], year

    obj = rolled_data.roll_data(stat, 10)

    respond_to do |format|
      format.json { render(:json => obj) }
    end
  end
end

