NotifyStudents = Struct.new(:notice_id) do
  def perform
    notice = Notice.find(notice_id)
    students = Student.where(email: notice.notice_emails).uniq
    students.each { |student| CosmetologyMailer.notify_student(student, notice).deliver }
  end
end