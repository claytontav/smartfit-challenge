class PageController < ApplicationController
  def index
  end

  def create 
    @period = params[:period]
    @units = params[:units]

    puts @period
    puts @units
  end
end
