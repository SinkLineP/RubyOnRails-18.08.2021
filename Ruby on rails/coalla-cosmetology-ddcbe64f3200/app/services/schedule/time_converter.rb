module Schedule
  class TimeConverter
    ACADEMIC_HOUR_IN_MINUTES = 45

    class << self
      def academic_hours_to_real_hours(academic_hours)
        (academic_hours * ACADEMIC_HOUR_IN_MINUTES / 60.0).round
      end

      def academic_hours_to_minutes(academic_hours)
        academic_hours * ACADEMIC_HOUR_IN_MINUTES * 60
      end
    end
  end
end