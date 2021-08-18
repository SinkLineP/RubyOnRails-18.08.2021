class CosmetologyMailerPreview
  def report_ready
    CosmetologyMailer.report_ready email, path
  end

  def info_corona_url
    CosmetologyMailer.notify_corona_virus_mail student
  end

  def new_sdo_url
    CosmetologyMailer.new_sdo_url student
  end


  def notify_blog_subscriber
    CosmetologyMailer.notify_blog_subscriber subscriber, post
  end


  def notify_student
    CosmetologyMailer.notify_student student, notice
  end


  def instructor_password_changed
    CosmetologyMailer.instructor_password_changed instructor
  end


  def sign_up
    CosmetologyMailer.sign_up user, subscription
  end


  def notify_about_new_courses
    CosmetologyMailer.notify_about_new_courses user, subscription
  end


  def feedback_question_mail
    CosmetologyMailer.feedback_question_mail email, feedback_question
  end


  def study_question_mail_without_instructor
    CosmetologyMailer.study_question_mail_without_instructor feedback_question, course
  end


  def new_password
    CosmetologyMailer.new_password user
  end


  def notify_extend_training
    CosmetologyMailer.notify_extend_training user, course
  end


  def send_student_order_contract
    CosmetologyMailer.send_student_order_contract order, student, contract
  end


  def send_student_contract
    CosmetologyMailer.send_student_contract student, contract, documents
  end


  def result_comment
    CosmetologyMailer.result_comment result
  end


  def lection_file_attached_notification
    CosmetologyMailer.lection_file_attached_notification result
  end


  def primary_treatment
    CosmetologyMailer.primary_treatment subscription
  end


  def meeting_status_notification
    CosmetologyMailer.meeting_status_notification subscription
  end


  def skdi_notification
    email = 'test@test.test'
    CosmetologyMailer.skdi_notification email, shop
  end


  def sk_notification
    email = 'test@test.test'
    CosmetologyMailer.sk_notification email, shop
  end


  def ke_notification
    email = 'test@test.test'
    CosmetologyMailer.ke_notification email, shop
  end


  def other_notification
    email = 'test@test.test'
    CosmetologyMailer.other_notification email, shop
  end


  def ks_notification
    email = 'test@test.test'
    CosmetologyMailer.ks_notification email, shop
  end


  def group_places_ended
    CosmetologyMailer.group_places_ended group
  end


  def vacancies_notification
    CosmetologyMailer.vacancies_notification user, vacancies, token
  end


  def block_cloned
    CosmetologyMailer.block_cloned block
  end


  def block_copied
    CosmetologyMailer.block_copied new_block, block
  end


  def failed_payment
    CosmetologyMailer.failed_payment params
  end


  def extraordinary_payment
    CosmetologyMailer.extraordinary_payment student, params
  end


  def building_entrance_changed
    CosmetologyMailer.building_entrance_changed student
  end


  def polling_result_send_mail
    CosmetologyMailer.polling_result_send_mail user
  end

  def shop
    Shop.default_shop
  end
end
