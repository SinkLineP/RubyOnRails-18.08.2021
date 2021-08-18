module Schedule
  module GroupDays
    def next_correct_day(group, day)
      next_day = day
      begin
        next_day += 1.day
      end while !correct_day?(group, next_day)
      next_day
    end

    def correct_day?(group, day)
      !holiday?(day) && group.correct_day?(day)
    end

    def holiday?(day)
      return false unless day
      @holidays ||= {}
      @holidays[day.year] ||= Holiday.with_year(day.year).pluck(:day)
      @holidays[day.year].include?(day)
    end
  end
end