class NotificationMailerPreview
  def notify_about_practice
    NotificationMailer.notify_about_practice student, group, subject
  end


  def notify_about_lecture
    NotificationMailer.notify_about_lecture student, subscription, subject
  end


  def notify_about_payment
    NotificationMailer.notify_about_payment student, payments
  end


  def notify_about_today_payment
    NotificationMailer.notify_about_today_payment student, payments
  end


  def notify_about_payment_debt
    NotificationMailer.notify_about_payment_debt student, payments
  end


  def notify_about_itec
    NotificationMailer.notify_about_itec student
  end


  def notify_about_end_of_education
    NotificationMailer.notify_about_end_of_education student
  end


  def notify_about_discount
    NotificationMailer.notify_about_discount student
  end


  def final_notification
    NotificationMailer.final_notification subscription
  end


  def notify_about_course_links
    NotificationMailer.notify_about_course_links student, course
  end


  def notify_about_academic_vacation
    NotificationMailer.notify_about_academic_vacation group_subscription
  end


  def notify_about_new_address
    NotificationMailer.notify_about_new_address student
  end


  def notify_about_new_documents
    NotificationMailer.notify_about_new_documents student
  end


  def notify_about_expulsion
    NotificationMailer.notify_about_expulsion expulsion, student
  end


  def notify_student_academic_debt
    NotificationMailer.notify_student_academic_debt student, work_title
  end


  def notify_admin_about_academic_debt
    NotificationMailer.notify_admin_about_academic_debt student, work_title
  end


  def notify_student_education_debt
    NotificationMailer.notify_student_education_debt student, lecture_names, work_names
  end


  def notify_before_first_practice
    NotificationMailer.notify_before_first_practice student
  end


  def notify_practice_access
    NotificationMailer.notify_practice_access student
  end


  def changed_group_title_notification
    NotificationMailer.changed_group_title_notification subscription
  end


  def notify_to_receive_diploma
    NotificationMailer.notify_to_receive_diploma group, student
  end


  def remind_about_course
    NotificationMailer.remind_about_course student
  end


  def remind_about_progress
    NotificationMailer.remind_about_progress student, progress
  end


  def notify_about_poor_progress_expulsion
    NotificationMailer.notify_about_poor_progress_expulsion subscription
  end


  def consultation
    NotificationMailer.consultation consultation
  end


  def subscription
    NotificationMailer.subscription subscription
  end


  def notify_about_expired_education_debts
    NotificationMailer.notify_about_expired_education_debts subscription
  end


  def requisites_changed
    NotificationMailer.requisites_changed student
  end


  def education_details_notification
    NotificationMailer.education_details_notification subscription
  end


  def institute_relocation_notification
    NotificationMailer.institute_relocation_notification student
  end


  def institute_relocation_notification_new_entrance
    NotificationMailer.institute_relocation_notification_new_entrance student
  end


  def subscription_success_notification
    NotificationMailer.subscription_success_notification subscription, tag
  end


  def notify_about_anniversary_refund
    NotificationMailer.notify_about_anniversary_refund student, payments_sum
  end

  def notify_about_materials_for_k_dist
    NotificationMailer.notify_about_materials_for_k_dist student
  end
end
