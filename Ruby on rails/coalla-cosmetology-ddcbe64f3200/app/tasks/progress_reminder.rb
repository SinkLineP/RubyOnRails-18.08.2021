class ProgressReminder
  def self.run
    ProgressReminder.new.run
  end

  def run
    period = Date.current - 1.week..Date.current

    Student.joins(:group_subscriptions, group_subscriptions: {group: :practices})
        .merge(GroupSubscription.with_long_courses)
        .where("group_subscriptions.end_on >= :date", date: Date.current)
        .where(group_subscriptions: {expelled: false})
        .where('practices.begin_on IS NOT NULL')
        .uniq.each do |student|
      courses = student.available_courses.select do |course|
        student.course_status(course) == :active &&
            student.lecture_status(course.lectures.last, course) != :current
      end

      next if courses.blank?

      progress = courses.map do |course|
        lecture_ids = course.lectures.map(&:id)
        lectures_count = UserActivity.where(user_id: student.id,
                                      created_at: period,
                                      trackable_type: 'Lecture',
                                      trackable_id: lecture_ids)
                       .select('DISTINCT trackable_id')
                       .to_a
                       .count
        task_ids = course.tasks.map(&:id)
        results = Result.where(student_id: student.id,
                               passed: true,
                               created_at: period,
                               task_id: task_ids)
        spent_time = UserActivity.where(user_id: student.id,
                                        created_at: period,
                                        trackable_type: 'Lecture',
                                        trackable_id: lecture_ids)
                         .sum(:spent_time).to_i + UserActivity.where(user_id: student.id,
                                                                     created_at: period,
                                                                     trackable_type: 'Result',
                                                                     trackable_id: results.map(&:id))
                                                      .sum(:spent_time).to_i
        not_passed_lectures = course.lectures.to_a.count { |l| student.lecture_status(l, course) == :unavailable }
        weeks_left = lectures_count > 0 ? not_passed_lectures / lectures_count : 0
        weeks_left = 1 if weeks_left == 0
        progress = OpenStruct.new(course: course,
                                  spent_time: spent_time,
                                  lectures: lectures_count,
                                  results: results.count,
                                  weeks_left: weeks_left)
      end
      NotificationMailer.remind_about_progress(student, progress).deliver!
    end
  end
end