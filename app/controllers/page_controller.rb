class PageController < ApplicationController
  def index
    response = GetDataJson.new.call
    @data_developer = JSON.parse(response)
  end

  def create 
    @period = params[:period]
    @units = params[:units]

    puts @period
    puts @units
  end
end
