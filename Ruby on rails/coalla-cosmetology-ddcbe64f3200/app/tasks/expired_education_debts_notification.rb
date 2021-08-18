class ExpiredEducationDebtsNotification

  THRESHOLD_VALUE = 60

  def self.run
    group_subscriptions = GroupSubscription.preload(:student,
                                                    :group,
                                                    group: [:course],
                                                    course: [{ blocks: { lectures: :task } }, :tasks],
                                                    student: [{ results: :task }, { student_work_results: [:course, :exercise_results, :work] }, :student_work_results, :results])
                            .joins(:course)
                            .where("courses.short_name ILIKE ANY ( array[?] )", %w(MDI KDI SKDI DDI).map { |val| "%#{val}%" })
                            .where('group_subscriptions.end_on = ?', Date.current - 1.day)

    group_subscriptions.find_each do |subscription|
      course = subscription.course
      student = subscription.student
      last_file_task = course.tasks.select(&:file?).last
      next unless last_file_task
      results = student.results.select { |result| result.task == last_file_task }
      notify = results.blank? || results.map{|r| r.mark.to_i}.max < THRESHOLD_VALUE
      NotificationMailer.notify_about_expired_education_debts(subscription).deliver! if notify
    end
  end
end