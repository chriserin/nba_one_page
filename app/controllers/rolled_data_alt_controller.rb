class RolledDataAltController < ApplicationController
  def show

    stat = params[:stat] || "points"
    rolled_data = Nba::RolledData.new params[:name]

    obj = rolled_data.roll_data(stat, 10)

    respond_to do |format|
      format.json { render(:json => obj) }
    end
  end
end

