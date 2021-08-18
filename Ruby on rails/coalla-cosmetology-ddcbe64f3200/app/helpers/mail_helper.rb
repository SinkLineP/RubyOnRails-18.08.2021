module MailHelper

  def long_time_notification_text(subscription)
    group = subscription.group
    "#{subscription.student.first_name}, у вас был изменен номер группы, новый номер группы - #{group.title}.
    Ваши сроки обучения #{format_date(group.begin_on)} - #{format_date(group.end_on)}, ваши даты и время практических занятий #{group.all_practice_periods_text}.
    Пожалуйста, свяжитесь с учебной частью для уточнения деталей. info@cosmeticru.com +74953746438"
  end

  def short_time_notification_text(subscription)
    group = subscription.group
    "#{subscription.student.first_name}, у вас был изменен номер группы, новый номер группы - #{group.title}.
    Ваши даты и время практических занятий #{group.all_practice_periods_text}. Пожалуйста, свяжитесь с учебной частью для уточнения деталей. info@cosmeticru.com +74953746438"
  end

  def short_time_sms_notification_text(subscription)
    group = subscription.group
    "У вас изменен № группы, новый № группы - #{group.title}. Даты и время практики #{group.all_practice_periods_text}. Институт ДРК."
  end

  def long_time_sms_notification_text(subscription)
    group = subscription.group
    "У вас изменен № группы, новый номер группы - #{group.title}. Ваши сроки обучения #{format_date(group.begin_on)} - #{format_date(group.end_on)}, ваши даты и время практических занятий #{group.all_practice_periods_text}. Институт ДРК."
  end

  def address_practice(subscription)
    subscription.group.practice_address || "Б.Татарская 35с3"
  end
end