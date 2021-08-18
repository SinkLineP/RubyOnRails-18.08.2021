module Schedule
  class GroupWork < OpenStruct
    def begin_at
      build_datetime(day, time)
    end

    def end_at
      build_datetime(day, time + work_duration.hours)
    end

    private

    def build_datetime(day, time)
      DateTime.new(day.year, day.month, day.day, time.hour, time.min, 0, Time.zone.formatted_offset).in_time_zone
    end
  end
end