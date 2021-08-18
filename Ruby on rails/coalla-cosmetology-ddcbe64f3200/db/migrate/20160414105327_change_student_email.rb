class ChangeStudentEmail < ActiveRecord::Migration
  def change
    Student.find_each do |student|
      if student.emails.present? && student.generated_email?
        email = student.emails.pop
        student.update_columns(email: email, emails: student.emails)
      end

      if student.emails.first == student.email
        student.emails.pop
        student.update_columns(emails: student.emails)
      end
    end
  end
end