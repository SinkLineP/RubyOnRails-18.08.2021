# frozen_string_literal: true

class CosmetologyMailer < ActionMailer::Base
  include LookupHelper
  add_template_helper(MailHelper)
  add_template_helper(ApplicationHelper)
  add_template_helper(TypographHelper)

  FROM = Rails.env.staging? ? '"Дом Русской Косметики" <no-reply@cosmetic.coalla.ru>' : '"Дом Русской Косметики" <info@cosmeticru.com>'
  BCC_EMAIL = (Rails.env.staging? ? ["dev@coalla.ru"] : ["cosmeticru@mail.amocrm.ru"])
  FEEDBACK_EMAIL = (Rails.env.staging? ? "dev@coalla.ru" : "support@cosmeticruhelp.zendesk.com")

  INFO_EMAIL = (Rails.env.staging? ? "at@coalla.ru" : "info@cosmeticru.com")
  GROUP_PLACES_ENDED_EMAILS = (Rails.env.staging? ? ["at@coalla.ru"] :
                                 %w(info@cosmeticru.com i.naumova@cosmeticru.com seva@cosmeticru.com at@coalla.ru o.nikiforova@cosmeticru.com i.udovichenko@cosmeticru.com))
  PAYMENTS_EMAILS = Rails.env.production? ? %w(info@cosmeticru.com a.nikanorova@cosmeticru.com) : %w(dev@coalla.ru)

  layout "mail", except: :vacancies_notification

  default from: FROM,
          bcc: BCC_EMAIL

  DEV_EMAIL = "dev@coalla.ru"

  def report_ready(email, path)
    @path = path
    mail(to: email, subject: "Отчёт о посещаемости готов", bcc: [])
  end

  def new_sdo_url(student)
    @student = student
    mail(to: @student.email, subject: "Важное сообщение - меняется адрес входа в СДО")
  end

  def notify_about_chat(student)
    mail(to: student.email, subject: "Надоело, что не можете дозвониться? Решение есть!")
  end

  def notify_blog_subscriber(subscriber, post)
    @post = post
    mail(to: subscriber.subscription_email, subject: @post.title)
  end

  def notify_student(student, notice)
    @student = student
    @notice = notice
    @notice.notice_attachments.each do |attached_file|
      attachments[attached_file.filename] = File.read(attached_file.file.path) if attached_file.file_url.present?
    end
    mail(to: student.email, subject: "#{student.text_for_subject('важное сообщение для учащихся, прочитать обязательно.')}")
  end

  def instructor_password_changed(instructor)
    @instructor = instructor
    mail(to: @instructor.email, subject: "Ваш пароль от системы дистанционного обучения изменен", bcc: [])
  end

  def sign_up(user, subscription)
    @user = user
    @subscription = subscription
    @shop = @subscription.shop
    @custom_sign = "<div><i>- Команда Школы Светланы Сикорской</i></div>" if @shop.barbershop?
    attachments["Памятка студентам.pdf"] = File.read(File.join(Rails.root, "public", "for_students.pdf")) if subscription.course_hours.to_i < Course.long_course_hours
    attachments[subscription.subscription_contract.file_name] = File.read(subscription.subscription_contract.path) if subscription.subscription_contract.present?
    attachments[subscription.practice_agreement.file_name] = File.read(subscription.practice_agreement.path) if subscription.practice_agreement.present?
    mail(to: user.email, subject: "#{user.text_for_subject('начало обучения в Доме Русской Косметики')}", cc: "irina@cosmeticru.com", bcc: [])
  end

  def notify_about_new_courses(user, subscription)
    @user = user
    @subscription = subscription
    attachments["Памятка студентам.pdf"] = File.read(File.join(Rails.root, "public", "for_students.pdf")) if subscription.course_hours.to_i < Course.long_course_hours
    if subscription.not_alone?
      order_contract = subscription.order_group_subscriptions.first.order.order_contract
      attachments[order_contract.file_name] = File.read(order_contract.path) if order_contract.present?
    else
      attachments[subscription.subscription_contract.file_name] = File.read(subscription.subscription_contract.path) if subscription.subscription_contract.present?
    end
    attachments[subscription.practice_agreement.file_name] = File.read(subscription.practice_agreement.path) if subscription.practice_agreement.present?
    mail(to: user.email, subject: "#{user.text_for_subject('открыт доступ к новым курсам в Доме Русской Косметики')}")
  end

  def feedback_question_mail(email, feedback_question)
    @feedback_question = feedback_question
    attachments[@feedback_question.filename] = @feedback_question.file.read if @feedback_question.file.present?
    mail(to: email, subject: "Вам поступил вопрос от студента", reply_to: feedback_question.student_email)
  end

  def study_question_mail_without_instructor(feedback_question, course)
    @feedback_question = feedback_question
    @course = course
    attachments[@feedback_question.filename] = @feedback_question.file.read if @feedback_question.file.present?
    mail(to: FEEDBACK_EMAIL, subject: "Вам поступил вопрос от студента", reply_to: feedback_question.student_email)
  end

  def new_password(user)
    @user = user
    mail(to: user.email, subject: "#{user.text_for_subject('ваш пароль был изменён')}", bcc: [])
  end

  def notify_extend_training(user)
    @user = user
    @expiring_subs = user.group_subscriptions.where(group_subscriptions: {end_on: Date.today - 5.month - 2.week})
    mail(to: user.email, subject: "#{user.text_for_subject('уведомление об окончании доступа в СДО')}")
  end

  def send_student_order_contract(order, student, contract)
    @student, @contract, @order = student, contract, order
    attachments[contract.file_name] = File.read(contract.full_path) if contract && contract.generated? && File.exist?(contract.full_path)
    mail(to: student.email, subject: "#{student.text_for_subject('договор на оказание платных образовательных услуг')}")
  end

  def send_student_contract(student, contract, documents)
    @student, @contract = student, contract
    documents.each do |document|
      attachments[document.file_name] = File.read(document.full_path) if document && document.generated? && File.exist?(document.full_path)
    end
    @doc_name = contract.contract? ? 'договор' : 'справка'
    @doc_name_roditelniy = contract.contract? ? 'договор' : 'справку'
    @doc_name_tvoritelniy = contract.contract? ? 'договора' : 'справки'
    if contract.item.government?
      mail(to: student.email, subject: "#{student.text_for_subject(@doc_name + ' на оказание образовательных услуг')}")
    else
      mail(to: student.email, subject: "#{student.text_for_subject(@doc_name + ' на оказание платных образовательных услуг')}")
    end
  end

  def result_comment(result)
    @result = result
    @student = @result.student
    mail(to: @student.email, subject: "#{@student.text_for_subject('комментарий преподавателя к заданию')}", bcc: [])
  end

  def lection_file_attached_notification(result)
    @user = result.student
    @group = result.group
    @instructor = @group.try(:instructor)
    @result = result
    mail(to: [@instructor.try(:email), INFO_EMAIL, "maria@cosmeticru.com"].reject(&:blank?), subject: "Загрузка карт или дипломной работы, #{@user.full_name}", bcc: [])
  end

  def primary_treatment(subscription)
    @subscription = subscription
    @user = subscription.student
    @custom_sign = "<div><i>С уважением, ректор Всеволод Бельченко</i></div><div><i>8(495)374-64-38</i></div>"
    attachments["Прочитайте основную информацию об Институте.pdf"] = File.read(File.join(Rails.root, "public", "Прочитайте основную информацию об Институте.pdf"))
    attachments["Узнайте как построить успешную карьеру в косметологии.pdf"] = File.read(File.join(Rails.root, "public", "Узнайте как построить успешную карьеру в косметологии.pdf"))
    mail(to: @user.email, subject: "Важная информация по обучению косметологии")
  end

  def meeting_status_notification(subscription)
    @subscription = subscription
    @user = subscription.student
    attachments["Схема как пройти.pdf"] = File.read(File.join(Rails.root, "public", "Схема как пройти.pdf"))
    mail(to: @user.email, subject: "Схема, как пройти от метро пешком до ДРК")
  end

  def skdi_notification(email, _shop)
    mail(to: email, subject: "Спасибо за оформление. Важная информация об обучении в Доме Русской Косметики")
  end

  def sk_notification(email, _shop)
    mail(to: email, subject: "Спасибо за оформление. Важная информация об обучении в Доме Русской Косметики")
  end

  def ke_notification(email, _shop)
    mail(to: email, subject: "Спасибо за оформление. Важная информация об обучении в Доме Русской Косметики")
  end

  def other_notification(email, shop)
    @shop = shop
    @custom_sign = "<div><i>- Команда Школы Светланы Сикорской</i></div>" if @shop.barbershop?
    attachments["Памятка студентам.pdf"] = File.read(File.join(Rails.root, "public", "for_students.pdf"))
    mail(to: email, subject: @shop.barbershop? ? "Спасибо за оформление!" : "Спасибо за оформление. Важная информация об обучении в Доме Русской Косметики")
  end

  def ks_notification(email, _shop)
    mail(to: email, subject: "Спасибо за оформление. Важная информация об обучении в Доме Русской Косметики")
  end

  def group_places_ended(group)
    @group = group
    mail(to: GROUP_PLACES_ENDED_EMAILS, subject: "Закончились места в группе #{@group.title}")
  end

  def vacancies_notification(user, vacancies, token)
    @user = user
    @vacancies = vacancies
    @token = token
    mail(to: user.email, subject: "Новые вакансии от Дома Русской Косметики")
  end

  def block_cloned(block)
    @block = block
    mail(to: Rails.env.staging? ? "dev@coalla.ru" : "irina@cosmeticru.com", subject: "Клонирование блока успешно завершено", bcc: [])
  end

  def block_copied(new_block, block)
    @new_block = new_block
    @block = block
    mail(to: Rails.env.staging? ? "dev@coalla.ru" : "irina@cosmeticru.com", subject: "Копирование блока #{@block.name} -> #{@new_block.name} успешно завершено", bcc: [])
  end

  def failed_payment(params)
    @params = params
    mail(to: PAYMENTS_EMAILS, subject: "Некорректные параметры платежа")
  end

  def extraordinary_payment(student, params)
    @student = student
    @params = params
    mail(to: PAYMENTS_EMAILS, subject: "Внеплановый платёж")
  end

  def building_entrance_changed(student)
    attachments["Смена входа в здание.pdf"] = File.read(File.join(Rails.root, "public", "building_entrance_changed.pdf"))
    mail(to: student.email, subject: "Смена входа в здание Института")
  end

  def polling_result_send_mail(user)
    @user = user
    mail(to: user.email, subject: "Оставьте отзыв об обучении!")
  end

  def notify_corona_virus_mail(student)
    attachments["Памятка - коронавирус.pdf"] = File.read(File.join(Rails.root, "public", "corona_virus.pdf"))
    @user = student
    mail(to: student.email, subject: "Изменения в работе института в связи с коронавирусом!")
  end
end
