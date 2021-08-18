module Schedule
  class GroupsWorksBuilder
    include GroupDays

    BREAK_IN_MINUTES = 30

    def initialize
      @min_work_duration = TimeConverter.academic_hours_to_real_hours(Work.where('duration > 0').minimum(:duration))
    end

    def build
      groups = load_groups
      result = []
      groups.map do |group|
        day_items = build_day_items(group)
        work_items = build_work_items(group)
        scheduled_works = build_group_works(group, day_items, work_items)
        next if scheduled_works.blank?
        result += scheduled_works
      end
      result
    end

    protected

    def load_groups
      Group.joins(:practices, course: :course_works)
        .preload(:practices, course: { course_works: :work })
        .where(active: true, fake: false, scheduled: false)
        .where('practices.end_on > ?', Date.current)
        .order(:begin_on)
        .distinct
    end

    def build_group_works(group, day_items, work_items)
      return [] if day_items.blank?
      last_day_item = day_items.first
      work_items_with_break = {}
      work_items.map do |work_item|
        new_day = day_items.first.try(:day)
        if work_item.work.break_days > 0
          new_day = work_items_with_break[work_item.work] + work_item.work.break_days.days if work_items_with_break[work_item.work]
          work_items_with_break[work_item.work] = new_day
        end

        day_item = day_items.detect { |item| item.day >= new_day && (item.end_time - item.start_time) >= work_item.work_duration.hours } if new_day
        if day_item
          last_day_item = day_item.dup
          day_item.start_time = day_item.start_time + work_item.work_duration.hours + BREAK_IN_MINUTES.minutes
          day_items.delete(day_item) if day_item.end_time - day_item.start_time < @min_work_duration.hours
        else
          new_day = next_correct_day(group, last_day_item.day)
          last_day_item = OpenStruct.new(day: new_day, start_time: last_day_item.original_start_time, end_time: last_day_item.original_start_time + work_item.work_duration.hours)
        end

        GroupWork.new(group: group,
                      work: work_item.work,
                      work_index: work_item.work_index,
                      work_duration: work_item.work_duration,
                      day: last_day_item.day,
                      time: last_day_item.start_time)
      end
    end

    def build_work_items(group)
      course_works = group.course.course_works
      practice_course_works = course_works.select(&:practice?)
      practice_course_works.flat_map do |course_work|
        works_count = (course_work.hours / course_work.work.duration.to_f).ceil
        (1..works_count).map do |index|
          OpenStruct.new(work: course_work.work,
                         work_duration: TimeConverter.academic_hours_to_real_hours(course_work.work.duration),
                         work_index: index)
        end
      end
    end

    def build_day_items(group)
      group.practices.flat_map do |practice|
        correct_days = (practice.begin_on..practice.end_on).select { |day| correct_day?(group, day) }
        correct_days.map { |day| OpenStruct.new(day: day, start_time: practice.start_time, end_time: practice.end_time, original_start_time: practice.start_time) }
      end.uniq { |day_item| [day_item.day, day_item.start_time, day_item.end_time] }
    end
  end
end