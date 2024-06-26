class ValidadSchedules
  def initialize(data_developer, period, units)
    @data_developer = data_developer
    @period = period
    @units = units
  end

  def call
    filter_locations
  end

  private

  def date_format(data_str)
    DateTime.parse("2000-01-01T#{data_str}:00")
  end

  def time_within_period?(start_time_str, end_time_str, period)
    array_period = {
      'morning' => ['06:00', '12:00'],
      'afternoon' => ['12:01', '18:00'],
      'night' => ['18:01', '23:00']
    }

    period_start_str, period_end_str = array_period[period]
    period_start = date_format(period_start_str)
    period_end = date_format(period_end_str)

    start_time = date_format(start_time_str)
    end_time = date_format(end_time_str)

    (start_time >= period_start && start_time <= period_end) ||
      (end_time >= period_start && end_time <= period_end) ||
      (start_time <= period_start && end_time >= period_end)
  end

  def filter_locations
    data_developer = JSON.parse(@data_developer)
    result_locations = data_developer['locations']

    filtered_locations = result_locations.map do |location|
      next unless location.key?('id') && location.key?('schedules')

      filtered_schedules = location['schedules'].select do |schedule|
        if schedule['hour'] != 'Fechada' && schedule['hour'] != nil && schedule['weekdays'] != 'Obs.:'
          schedule_start_time, schedule_end_time = schedule['hour'].split(' às ')
          start_time = schedule_start_time.gsub(/(\d{2})h/, '\1:00')
          end_time = schedule_end_time.gsub(/(\d{2})h/, '\1:00')

          time_within_period?(start_time, end_time, @period)
        elsif schedule['weekdays'] == 'Obs.:'
          true
        elsif schedule['hour'] == 'Fechada'
          if @units == '1'
            true
          end
        end
      end

      location.merge('schedules' => filtered_schedules) if filtered_schedules.any?
    end.compact
  end
end
