# frozen_string_literal: true

NotifyStudentsNewEntranceJob = Struct.new(:flag) do
  def perform
    student_ids = GroupSubscription.actual
                              .not_expelled
                              .not_academic_vacation
                              .actual_practices
                              .pluck(:student_id).uniq
    students = Student.where(id: student_ids)
    students.each do |student|
      NotificationMailer.institute_relocation_notification_new_entrance(student).deliver
    end
  end
end
