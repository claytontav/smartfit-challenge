class ValidadSchedules
  def initialize(data_developer, period, units)
    @data_developer = data_developer
    @period = period
    @units = units
  end

  def call 
    filter_schedules_by_period(filter_locations_with_schedules(@data_developer), @period, @units)
  end

  private

  def filter_locations_with_schedules(locations_hash)
    locations = locations_hash['locations']

    locations.select do |location|
      location.key?('schedules') && location['schedules'].any?
    end
  end

  def filter_schedules_by_period(locations, period, units)
    start_time, end_time = case period
      when 'morning'
        ['06:00', '12:00']
      when 'afternoon'
        ['12:01', '18:00']
      when 'night'
        ['18:01', '23:00']
      else
        raise ArgumentError, "Invalid period: #{period}"
    end
  
    locations.map do |location|
      filtered_schedules = location['schedules'].select do |schedule|
        if schedule['hour'] == 'Fechada' || schedule['weekdays'] == 'Fechada'
          units == '1'
        else
          schedule_start_time, schedule_end_time = schedule['hour'].split(' às ')
          next unless schedule_start_time && schedule_end_time
  
          time_within_period?(schedule_start_time, schedule_end_time, start_time, end_time)
        end
      end
  
      if filtered_schedules.any?
        location.merge('schedules' => filtered_schedules)
      end
    end.compact
  end
    
  def time_within_period?(schedule_start_time, schedule_end_time, start_time, end_time)
    (schedule_start_time <= end_time && schedule_end_time >= start_time)
  end
end