class NotificationMailer < ActionMailer::Base
  include LookupHelper
  add_template_helper(ApplicationHelper)
  add_template_helper(TypographHelper)
  add_template_helper(MailHelper)
  add_template_helper(ProgressHelper)
  add_template_helper(Documents::DocumentsHelper)

  FROM = Rails.env.staging? ? '"Дом Русской Косметики" <no-reply@cosmetic.coalla.ru>' : '"Дом Русской Косметики" <info@cosmeticru.com>'
  INFO_EMAIL = Rails.env.staging? ? 'dev@coalla.ru' : 'info@cosmeticru.com'
  COPY_EMAIL = Rails.env.staging? ? 'dev@coalla.ru' : 'cosmeticru@mail.amocrm.ru'

  layout 'mail', except: [:education_details_notification, :notify_about_anniversary_refund]

  default from: FROM,
          bcc: [COPY_EMAIL]


  def notify_about_practice(student, group, subject)
    @student = student
    @group = group
    mail(to: student.email, subject: student.text_for_subject(subject))
  end

  def notify_about_lecture(student, subscription, subject)
    @student = student
    @subscription = subscription
    mail(to: student.email, subject: student.text_for_subject(subject))
  end

  def notify_about_payment(student, payments)
    @student = student
    @payments = payments
    course_names, shop_codes = [], []
    @payments.each do |p|
      course_names << p.course.name
      shop_codes << p.course.shop.code
    end
    @urls = []
    domain_names = {'cosmetic' => 'ДРК', 'barbershop' => 'ШСС'}
    shop_codes.uniq.each { |code| @urls << [domain_names[code], courses_shop_profile_courses_url(domain: Rails.application.secrets.shops_domains[code], subdomain: '')] }
    attachments['Инструкция по онлайн оплате обучения.pdf'] = File.read('public/payment_instruction.pdf')
    mail(to: student.email, subject: "#{student.text_for_subject('платеж за обучение по курсам:')} #{course_names.uniq.join(', ')}")
  end

  def notify_about_today_payment(student, payments)
    @student = student
    @payments = payments
    course_names, shop_codes = [], []
    @payments.each do |p|
      course_names << p.course.name
      shop_codes << p.course.shop.code
    end
    @urls = []
    domain_names = {'cosmetic' => 'ДРК', 'barbershop' => 'ШСС'}
    shop_codes.uniq.each { |code| @urls << [domain_names[code], courses_shop_profile_courses_url(domain: Rails.application.secrets.shops_domains[code], subdomain: '')] }
    attachments['Инструкция по онлайн оплате обучения.pdf'] = File.read('public/payment_instruction.pdf')
    mail(to: student.email, subject: "#{student.text_for_subject('платеж за обучение по курсам:')} #{course_names.uniq.join(', ')}")
  end

  def notify_about_payment_debt(student, payments)
    @student = student
    @payments = payments
    course_names, shop_codes = [], []
    @payments.each do |p|
      course_names << p.course.name
      shop_codes << p.course.shop.code
    end
    @urls = []
    domain_names = {'cosmetic' => 'ДРК', 'barbershop' => 'ШСС'}
    shop_codes.uniq.each { |code| @urls << [domain_names[code], courses_shop_profile_courses_url(domain: Rails.application.secrets.shops_domains[code], subdomain: '')] }
    attachments['Инструкция по онлайн оплате обучения.pdf'] = File.read('public/payment_instruction.pdf')
    mail(to: student.email, subject: "#{student.text_for_subject('платеж за обучение по курсам:')} #{course_names.uniq.join(', ')}")
  end

  def notify_about_itec(student)
    @student = student
    mail(to: student.email, subject: "#{student.text_for_subject('диплом ITEC уже в Москве!')}")
  end

  def notify_about_end_of_education(student)
    @student = student
    mail(to: student.email, subject: "#{student.text_for_subject('окончание обучения в Доме Русской Косметики')}")
  end

  def notify_about_discount(student)
    @student = student
    @custom_sign = '<div><i>С уважением,</i></div><div><i>команда института «Дом Русской Косметики»</i></div>'
    mail(to: student.email, subject: "#{student.text_for_subject('дарим вам скидку на день рождения!')}")
  end

  def final_notification(subscription)
    @subscription = subscription
    @student = subscription.student
    @custom_sign = '<div><i>С уважением,</i></div><div><i>команда института «Дом Русской Косметики»</i></div>'
    mail(to: @student.email, subject: "#{@student.text_for_subject('спасибо за обучение, помогите нам стать лучше!')}")
  end

  def notify_about_course_links(student, course)
    @student = student
    @course = course
    @custom_sign = '<div><i>С уважением,</i></div><div><i>команда института «Дом Русской Косметики»</i></div>'
    mail(to: student.email, subject: "#{student.text_for_subject('специальное предложение для студентов Института')}")
  end

  def notify_about_academic_vacation(group_subscription)
    @student = group_subscription.student
    @subscription = group_subscription
    mail(to: @student.email, subject: "#{@student.text_for_subject('вам предоставлен академический отпуск')}")
  end

  def notify_about_new_address(student)
    @student = student
    attachments['Новый офис.pdf'] = File.read('public/new_office.pdf')
    mail(to: @student.email, subject: 'Внимание, с 10 сентября занятия проходят по новому адресу!')
  end

  def notify_about_new_documents(student)
    @student = student
    mail(to: @student.email, subject: 'Важное обновление в СДО, некоторые материалы могут быть недоступны')
  end

  def notify_about_expulsion(expulsion, student)
    @expulsion = expulsion
    @student = student
    reasons = []
    reasons << 'личным заявлением' if @expulsion.personal?
    reasons << 'непосещением занятий' if @expulsion.non_attendance?
    @reason = reasons.join(' и ')
    mail(to: @student.email, subject: "#{@student.text_for_subject('уведомление об отчислении')}")
  end

  def notify_student_academic_debt(student, work_title)
    @student = student
    @work_title = work_title
    mail(to: @student.email, subject: "#{@student.text_for_subject('важно, пересдача экзамена')}")
  end

  def notify_admin_about_academic_debt(student, work_title)
    @student = student
    @work_title = work_title
    mail(to: INFO_EMAIL, subject: "#{@student.text_for_subject('пересдача')}")
  end

  def notify_student_education_debt(student, lecture_names, work_names)
    @student = student
    @lecture_names = lecture_names
    @work_names = work_names
    mail(to: @student.email, subject: "#{@student.text_for_subject('важно: срочно закройте задолженности по обучению')}")
  end

  def notify_before_first_practice(student)
    @student = student
    mail(to: @student.email, subject: "#{@student.text_for_subject('пришлите копии документов об образовании')}")
  end

  def notify_practice_access(student)
    @student = student
    mail(to: @student.email, subject: "#{@student.text_for_subject('пришлите копии документов для допуска к практике')}")
  end

  def changed_group_title_notification(subscription)
    @long_course = subscription.course.long?
    @subscription = subscription
    @student = @subscription.student
    mail(to: @student.email, subject: "#{@student.text_for_subject('смена № группы')}")
  end

  def notify_to_receive_diploma(group, student)
    @student = student
    @group = group
    mail(to: student.email, subject: "#{student.text_for_subject('важно, заберите ваш диплом')}")
  end

  def remind_about_course(student)
    @student = student
    mail(to: student.email, subject: "#{student.name_for_subject}Дом Русской Косметики. Дистанционное обучение", bcc: [INFO_EMAIL, COPY_EMAIL])
  end

  def remind_about_progress(student, progress)
    @student = student
    @progress = progress
    mail(to: student.email, subject: "#{student.name_for_subject}Дом Русской Косметики. Журнал прогресса", bcc: [INFO_EMAIL, COPY_EMAIL])
  end

  def notify_about_poor_progress_expulsion(subscription)
    @student = subscription.student
    @group_subscription = subscription
    @date = @group_subscription.expulsion_notification.created_on
    attachments['Уведомление об отчислении.pdf'] = File.read(@group_subscription.expulsion_notification.path) if @group_subscription.expulsion_notification.present?
    mail(to: @student.email, subject: "#{@student.text_for_subject('уведомление о предстоящем отчислении')}", bcc: [INFO_EMAIL, COPY_EMAIL])
  end

  def consultation(consultation)
    @consultation = consultation
    mail(to: INFO_EMAIL, subject: 'Запись на консультацию')
  end

  def subscription(subscription)
    @subscription = subscription
    mail(to: INFO_EMAIL, subject: 'Горячий лид(запись студента в группу).')
  end

  def notify_about_expired_education_debts(subscription)
    @group_subscription = subscription
    @student = @group_subscription.student
    mail(to: @student.email, subject: 'Окончание обучения по курсу')
  end

  def requisites_changed(student)
    @student = student
    mail(to: @student.email, subject: ' Важное сообщение от Института: смена реквизитов для платежей')
  end

  def education_details_notification(subscription)
    @subscription = subscription
    @course = @subscription.course
    @user = @subscription.student
    @video_url = { 'K' => 'https://player.vimeo.com/video/283056857',
                   'KO' => 'https://player.vimeo.com/video/283057118',
                   'KOV' => 'https://player.vimeo.com/video/283057305',
                   'KV' => 'https://player.vimeo.com/video/283057496',
                   'KC' => 'https://player.vimeo.com/video/283057004',
                   'SK' => 'https://player.vimeo.com/video/283057678' }[@course.short_name]
    mail(to: @user.email, subject: 'Узнайте, как будет проходить ваше обучение')
  end

  def institute_relocation_notification(student)
    @student = student
    attachments['Новый офис.pdf'] = File.read('public/new_office.pdf')
    mail(to: @student.email, subject: 'Мы переехали в новый просторный офис!')
  end

  def institute_relocation_notification_new_entrance(student)
    @student = student
    attachments['Новый_вход.jpg'] = File.read('public/plan-new-entrance.jpg')
    mail(to: @student.email, subject: 'Важно: с 27 июля меняется вход в институт')
  end

  def subscription_success_notification(subscription, tag)
    @subscription = subscription
    @student = subscription.student
    @tag = tag
    attachments['Как загрузить документы в личный кабинет.pdf'] = File.read('public/documents_upload_instruction.pdf')
    mail(to: @student.email, subject: 'Мы ждем ваши документы')
  end

  def notify_about_anniversary_refund(student, payments_sum)
    @payments_sum = payments_sum.round
    @refund = (payments_sum * 0.3).round
    @student = student
    mail(to: @student.email, subject: "Возвращаем вам #{@refund} р., только до 20.06")
  end

  def notify_about_tech_error(student)
    @student = student
    mail(to: student.email, subject: "Обучение бесплатно, оплата не требуется, не волнуйтесь!")
  end

  def institute_break_notify(email)
    mail(to: email, subject: "Перерыв в работе института в связи с карантином")
  end

  def notify_about_webinar(student, webinar_link)
    @student = student
    @webinar_link = webinar_link
    mail(to: student.email, subject: "Вебинар начнется через час")
  end

  def notify_about_missing_student_docs(student)
    @student = student
    mail(to: student.email, subject: "Необходимо предоставить документы")
  end

  def notify_about_materials_for_k_dist(student)
    @student = student
    mail(to: student.email, subject: "Список материалов для обучения по курсу")
  end

  def cashback(email, sum)
    @sum = sum
    mail(to: email, subject: "Дарим #{sum}р. на обучение, только до 20 декабря!")
  end
end