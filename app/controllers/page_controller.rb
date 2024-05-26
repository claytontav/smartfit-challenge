class PageController < ApplicationController
  def index
    @data_developer = JSON.parse(GetDataJson.new.call)
  end

  def create 
    period = params[:period]
    units = params[:units]

    data_developer = GetDataJson.new.call
    filtered_data = ValidadSchedules.new(data_developer, period, units).call
    
    ActionCable.server.broadcast 'channel_schedule', filtered_data
  end
end
