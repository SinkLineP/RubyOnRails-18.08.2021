class RatingActualizer

  HOURS = 10
  HOURS_SCORE = 100
  SECONDS_IN_HOUR = 3600

  def run
    group_subscriptions = GroupSubscription
                            .preload(:student,
                                     :group,
                                     group: [:course],
                                     course: [{ blocks: { lectures: :task } }, :tasks],
                                     student: [{ results: :task }, {student_work_results: [:course, :exercise_results, :work]}, :student_work_results, :results, :user_activities])
                            .joins(:student)
                            .where(users: { demo: false })
                            .actual
                            .not_expelled
                            .not_academic_vacation
                            .not_ended
                            .ordered

    group_subscriptions.find_each do |subscription|
      student = subscription.student
      course = subscription.course
      course_activities = activity_for_course(student, course)
      total_seconds = course_activities.sum(&:spent_time)
      hours_index = total_seconds / (HOURS * SECONDS_IN_HOUR)
      sum_score = course.tasks.select(&:final?).sum do |task|
        results = student.results.select { |result| result.task == task && result.passed? }
        results.any? ? results.map { |r| r.try(:mark).to_i }.sort.reverse.first : 0
      end
      result = hours_index * HOURS_SCORE + sum_score + student_work_results_total(student, course)
      subscription.update_column(:rating_score, result)
    end

    group_subscriptions.group_by { |s| s.course.id }.each do |_course, subscriptions|
      rating_groups = subscriptions.group_by(&:rating_score).sort_by { |key, _value| key }.reverse
      current_place = 1
      rating_groups.each do |group|
        group.second.each { |rating_subscription| rating_subscription.update_column(:rating_place, current_place) }
        current_place += group.second.count
      end
    end

  rescue => ex
    Rails.logger.error("Failed to actualize rating. #{ex.message}")
    CustomExceptionNotifier.notify_exception(ex)
  end

  private

  def activity_for_course(student, course)
    lecture_activities = student.user_activities.where(trackable: course.lectures)
    task_activities = student.user_activities.where(trackable: results_for_course(student, course))
    activities = (lecture_activities.to_a + task_activities.to_a)
    activities.sort_by(&:last_tracked_at).reverse
  end

  def results_for_course(student, course)
    student.results.select { |result| course.tasks.include?(result.task) }
  end

  def student_work_results_total(student, course)
    student_work_results = student.student_work_results.includes(:course).where(absent: false, courses: { id: course.id })
    student_work_results.to_a.sum(&:total_mark_for_rating)
  end
end