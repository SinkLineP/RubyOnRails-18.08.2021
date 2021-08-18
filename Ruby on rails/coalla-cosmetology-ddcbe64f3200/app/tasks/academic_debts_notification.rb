class AcademicDebtsNotification

  def self.run
    Group.joins(:course).where('end_on::date = ?', Date.current + 2.weeks).where('courses.hours > 100').each do |group|
      course = group.course
      student_work_results = group.work_results.includes(:work).where(works: {type: %w(Exam PracticeWork)}).flat_map(&:student_work_results)
      actual_student_work_results = student_work_results.select { |result| result.group_subscription && result.group_subscription.active? }

      group.students.each do |student|
        course_lectures = course.lectures.pluck(:id)
        passed_lectures = student.results.passed.joins(:task).pluck(:lecture_id)
        not_passed_lectures = course.lectures.where(id: course_lectures - passed_lectures).map(&:description)
        practice_debts = actual_student_work_results.select do |r|
          r.student_id == student.id && !r.work_passed?
        end.map(&:work_title)

        next if not_passed_lectures.blank? || practice_debts.blank?

        NotificationMailer.notify_student_education_debt(student, not_passed_lectures, practice_debts).deliver!
      end
    end
  end
end