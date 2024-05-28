class PageController < ApplicationController
  def index
    if FilteredDatum.count > 0
      @data_developer = JSON.parse(FilteredDatum.last.data)
    else
      @data_developer = []
    end

    FilteredDatum.destroy_all
  end

  def create
    period = params[:period]
    units = params[:units]

    data_developer = GetDataJson.new.call
    filtered_data = ValidadSchedules.new(data_developer, period, units).call

    filtered_data_record = FilteredDatum.create(data: filtered_data.to_json)

    redirect_to root_path
  end
end
