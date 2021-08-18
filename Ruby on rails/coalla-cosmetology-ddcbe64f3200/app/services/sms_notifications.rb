class SmsNotifications
  include ApplicationHelper
  include MailHelper

  COPY = '89032523518'

  def notify_about_practice!(subscription)
    student = subscription.student
    group = subscription.group
    practice = group.practices.first
    text = "#{student.first_name.presence || student.email}, напоминаем, что #{format_date_full(practice.begin_on)}, #{format_time(practice.start_time)} - #{format_time(practice.end_time)} состоится первое практическое занятие в Доме Русской Косметики. При опоздании на 15 мин. и более вас могут не допустить до занятия. Адрес #{address_practice(subscription)}"
    notify(student.phone, text, student: student, subscription: subscription)
  end

  def notify_about_lecture!(subscription)
    student = subscription.student
    text = "#{student.first_name.presence || student.email}, напоминаем, что #{format_date_full(subscription.academic_on)}, #{format_time(subscription.start_time)} - #{format_time(subscription.end_time)} состоится первая лекция в Доме Русской Косметики. При опоздании на 15 мин. и более вас могут не допустить до занятия."
    notify(student.phone, text, student: student, subscription: subscription)
  end

  def notify_before_practice!(subscription)
    student = subscription.student
    group = subscription.group
    practice = group.practices.first
    practices_text = group.practices.offset(1).map { |practice| "#{practice_range_text(practice)} #{practice.formatted_start_time}-#{practice.formatted_end_time}" }.join(",\s")
    text = subscription.shop.barbershop? ? "#{student.first_name.presence || student.email}, напоминаем, что вы записаны #{practice_range_text(practice)}, #{format_time(practice.start_time)} - #{format_time(practice.end_time)}#{practices_text.present? ? " (#{practices_text})" : ''} на курс #{group.course.name}. При опоздании на 15 мин. и более вас могут не допустить до занятия. Приятной учебы! Адрес #{address_practice(subscription)}" :
                                           "#{student.first_name.presence || student.email}, напоминаем, что вы записаны #{practice_range_text(practice)}, #{format_time(practice.start_time)} - #{format_time(practice.end_time)}#{practices_text.present? ? " (#{practices_text})" : ''} на курс #{group.course.name}. Вы будете допущены на занятия только в медицинской форме - халате и сменной медицинской обуви. При опоздании на 15 мин. и более вас могут не допустить до занятия. Приятной учебы! Адрес #{address_practice(subscription)}"
    notify(student.phone, text, student: student, subscription: subscription)
  end

  def notify_about_payment!(student, payments)
    payment = payments.first
    subscription = payment.group_subscription
    text = "#{student.first_name.presence || student.email}, напоминаем, что до #{format_date_full(payment.payed_on)} Вам необходимо заплатить за обучение в Доме Русской Косметики."
    text +=  payments.map { |payment| " по курсу #{payment.course.name} сумма платежа: #{payment.amount} руб." }.join(',')
    text += ' Благодарим за своевременную оплату.'
    notify(student.phone, text, student: student, subscription: subscription)
  end

  def notify_about_today_payment!(student, payments)
    payment = payments.first
    subscription = payment.group_subscription
    text = "#{student.first_name.presence || student.email}, напоминаем, что сегодня Вам необходимо заплатить за обучение в Доме Русской Косметики."
    text += payments.map { |payment| " по курсу #{payment.course.name} сумма платежа: #{payment.amount} руб." }.join(',')
    text += ' В случае нарушения сроков оплаты вас не допустят к занятиям.'
    notify(student.phone, text, student: student, subscription: subscription)
  end

  def notify_about_payment_debt!(student, payments)
    payment = payments.first
    subscription = payment.group_subscription
    text = "Ваш долг за обучение по курсам составляет:"
    text +=  payments.map { |payment| " по курсу #{payment.course.name} долг: #{payment.amount} руб." }.join(',')
    text += ' Срочно свяжитесь с учебной частью по вопросу погашения задолженности. Если у вас есть задолженность за обучение, вас не допустят к занятиям.'
    notify(student.phone, text, student: student, subscription: subscription)
  end

  def notify_about_itec!(subscription)
    student = subscription.student
    text = 'Ваш диплом ITEC уже в Москве. Вы можете забрать его в Институте в будние дни с 10.00 до 19.00.'
    notify(student.phone, text, student: student, subscription: subscription)
  end

  def notify_about_end_of_education!(subscription)
    student = subscription.student
    text = "#{student.first_name.presence || student.email}, поздравляем с окончанием обучения в Доме Русской Косметики! Не забудьте забрать свою форму и обувь из гардероба."
    notify(student.phone, text, student: student, subscription: subscription)
  end

  def notify_about_new_address!(student)
    notify(student.phone, 'Добрый день, напоминаем, что с 10.09.2018 адрес занятий изменился: Б.Татарская ул. 35 с 3')
  end

  def notify_about_new_documents!(student)
    notify(student.phone, 'В СДО обновились материалы, некоторые лекции могут быть недоступны. Проверьте e-mail.')
  end

  def notify_about_group_changing!(subscription)
    student = subscription.student
    text = subscription.course.long? ? long_time_sms_notification_text(subscription) : short_time_sms_notification_text(subscription)
    notify(student.phone, text, student: student, subscription: subscription)
  end

  def notify_about_discount!(student)
    text = "Поздравляем Вас с наступающим Днем рождения и дарим скидку 10% на обучение! Скидка действует в течение двух недель до и после Дня рождения. Запишитесь на обучение сегодня: +7(495)3746438"
    notify(student.phone, text, student: student)
  end

  def notify_about_webinar!(student, webinar_link)
    text = "Вебинар начнется через час, ссылка #{webinar_link}"
    notify(student.phone, text, student: student)
  end

  private

  def notify(phone, text, options = {})
    Sms.send_message!(phone, text, options)
  end
end