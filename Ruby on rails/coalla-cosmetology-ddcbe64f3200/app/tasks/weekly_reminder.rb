class WeeklyReminder
  def self.run
    WeeklyReminder.new.run
  end

  def run
    Student.joins(:group_subscriptions, group_subscriptions: {group: :practices})
        .merge(GroupSubscription.with_long_courses)
        .where('group_subscriptions.end_on >= :date', date: Date.current)
        .where(group_subscriptions: {expelled: false})
        .where('practices.begin_on IS NOT NULL')
        .uniq.each do |student|
      remind = student.available_courses.any? do |course|
        next if student.user_activities.where('last_tracked_at >= ?', Date.current - 1.week).any?

        student.course_status(course) == :active &&
            student.lecture_status(course.lectures.last, course) != :current
      end

      NotificationMailer.remind_about_course(student).deliver! if remind
    end
  end
end