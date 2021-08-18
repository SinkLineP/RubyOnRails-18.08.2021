module Students
  class CourseTimeMarkers
    def initialize(student, course)
      @student = student
      @course = course
    end

    def lag_time_for_course
      return 0 if @student.course_passed?(@course)
      course_passed_days - course_expected_days
    end

    def course_passed_days
      conditions = []
      course_results_ids = @student.results.where(task: @course.tasks.map(&:id)).pluck(:id)
      conditions << "(trackable_type = 'Result' AND trackable_id IN (#{course_results_ids.join(',')}))" if course_results_ids.present?
      course_lectures_ids = @course.lectures.map(&:id)
      conditions << "(trackable_type = 'Lecture' AND trackable_id IN (#{course_lectures_ids.join(',')}))" if course_lectures_ids.present?
      return 0 if conditions.blank?
      course_activity_times = @student.user_activities.where(conditions.join(' OR ')).unscope(:order).pluck(:last_tracked_at).sort
      start_at = course_activity_times.first
      return 0 if start_at.blank?
      end_at = course_activity_times.last
      (end_at - start_at).to_i / 1.day
    end

    def course_expected_days
      return 0 unless @course.lectures.exists?
      average_lecture_days = @course.expected_days.to_f / @course.lectures.count
      passed_lectures = @student.results_for_course(@course).passed.pluck(:task_id).uniq.count
      ((passed_lectures + 1) * average_lecture_days).round
    end
  end
end