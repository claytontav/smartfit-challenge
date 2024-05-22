class PageController < ApplicationController
  def index
    @data_developer = JSON.parse(GetDataJson.new.call)
  end

  def create 
    period = params[:period]
    units = params[:units]

    data_developer = JSON.parse(GetDataJson.new.call)
    filtered_data = ValidadSchedules.new(data_developer, period, units).call
    
    puts filtered_data
  end
end
