# frozen_string_literal: true

class NotificationsService
  COURSES_WITHOUT_NOTIFICATION_ABOUT_PRACTICE_ACCESS = ['K-WSR', 'PU-WSR', 'UT-WSR', 'UL-WSR-Med', 'UL-WSR-BM', 'M-WSR', 'WSR-MOBIR'].freeze

  def self.run
    NotificationsService.new.run
  end

  def run
    notify_about_practice(5.days, "Скоро начнутся практические занятия в Доме Русской Косметики")
    notify_about_practice(3.days, "До первого занятия всего три дня!")

    notify_about_lecture(5.days, "Скоро начнутся лекции в Доме Русской Косметики")
    notify_about_lecture(3.days, "До первой лекции всего три дня!")

    notify_before_practice

    notify_about_payment(Date.current + 5.days) do |payment_results|
      payment_results.each do |student, payments|
        NotificationMailer.notify_about_payment(student, payments).deliver!
        SmsNotifications.new.notify_about_payment!(student, payments)
      end
    end

    notify_about_payment(Date.current) do |payment_results|
      payment_results.each do |student, payments|
        NotificationMailer.notify_about_today_payment(student, payments).deliver!
        SmsNotifications.new.notify_about_today_payment!(student, payments)
      end
    end

    notify_about_payment(Date.current - 3.days) do |payment_results|
      payment_results.each do |student, payments|
        debt_payments = payments.select { |payment| payment.group_subscription.sale_success_on < (Time.current - 5.days) }
        next if debt_payments.blank?
        NotificationMailer.notify_about_payment_debt(student, debt_payments).deliver!
        SmsNotifications.new.notify_about_payment_debt!(student, debt_payments)
      end
    end

    notify_about_end_of_education

    notify_about_discount

    final_notification

    notify_before_first_practice

    notify_practice_access

    notify_to_receive_diploma

    notify_about_education_details
  end

  private

  def notify_to_receive_diploma
    Expulsion.joins(:group).where(groups: { end_on: Date.current - 10.weeks }).expelled_not_by_hands.find_each do |expulsion|
      expulsion.expelled_students.each do |expelled_student|
        NotificationMailer.notify_to_receive_diploma(expulsion.group, expelled_student.student).deliver!
      end
    end
  end

  def notify_practice_access
    scope = GroupSubscription.with_long_courses.actual
    scope = scope.without_courses(COURSES_WITHOUT_NOTIFICATION_ABOUT_PRACTICE_ACCESS).where(practice: :institute)
    scope.find_each do |subscription|
      NotificationMailer.notify_practice_access(subscription.student).deliver! if subscription.group.first_practice_after_days?(14)
    end
  end

  def notify_before_first_practice
    GroupSubscription.with_short_courses.actual.find_each do |subscription|
      NotificationMailer.notify_before_first_practice(subscription.student).deliver! if subscription.group.first_practice_after_days?(5)
    end
  end

  def notify_about_course_links
    GroupSubscription.actual.with_long_courses.with_course_links.where(end_on: Date.current - 1.month).find_each do |subscription|
      NotificationMailer.notify_about_course_links(subscription.student, subscription.course).deliver!
    end
  end

  def final_notification
    GroupSubscription.actual.where(end_on: Date.current).find_each do |subscription|
      unless subscription.student.mailing_journals.was_mailing_about?("final_notification", 1.month)
        NotificationMailer.final_notification(subscription).deliver!
        subscription.student.create_journal_entry_final_notification_about
      end
    end
  end

  def notify_about_discount
    Student.where("date_part('day', users.birthday) = ? AND date_part('month', users.birthday) = ?", (Date.current + 15.days).day, Date.current.month).find_each do |student|
      NotificationMailer.notify_about_discount(student).deliver!
      SmsNotifications.new.notify_about_discount!(student)
    end
  end

  def notify_about_end_of_education
    GroupSubscription.actual.with_long_courses.where(end_on: Date.current,
                                                     practice: :institute).find_each do |subscription|
      NotificationMailer.notify_about_end_of_education(subscription.student).deliver!
      SmsNotifications.new.notify_about_end_of_education!(subscription)
    end
  end

  def notify_about_payment(date)
    payment_results = {}
    Payment.joins(:group_subscription).where(payed_on: date).merge(GroupSubscription.actual.not_expelled.not_academic_vacation.not_government.disabled_send).find_each do |payment|
      subscription = payment.group_subscription
      payment_logs = PaymentLog.where(group_id: subscription.group_id, student_id: subscription.student_id).to_a

      plan = subscription.payments.select { |p| p.payed_on && p.payed_on <= date }.sum(&:amount) || 0
      fact = payment_logs.select { |p| p.group_id == subscription.group_id && p.student_id == subscription.student_id }.sum(&:amount) || 0

      next if fact >= plan

      payment_results[subscription.student] ||= []
      payment_results[subscription.student] << payment
    end
    yield(payment_results)
  end

  def notify_before_practice
    Group.with_short_courses.with_practice(Date.current + 1.day).uniq.find_each do |group|
      next if group.practices.first.begin_on.to_date != Date.current + 1.day
      group.active_students.each do |student|
        group_subscription = group.subscriptions.where(student_id: student.id).first
        SmsNotifications.new.notify_before_practice!(group_subscription)
      end
    end
  end

  def notify_about_lecture(days, text)
    GroupSubscription.joins(:group).actual.with_long_courses.where(groups: { academic_on: Date.current + days },
                                                                   education_form: EducationForm.offline).find_each do |subscription|
      NotificationMailer.notify_about_lecture(subscription.student, subscription, text).deliver!
      SmsNotifications.new.notify_about_lecture!(subscription)
    end
  end

  def notify_about_practice(days, text)
    Group.with_long_courses.with_practice(Date.current + days).uniq.find_each do |group|
      next if group.practices.first.begin_on.to_date != Date.current + days
      group.active_students.find_each do |student|
        group_subscription = group.subscriptions.where(student_id: student.id).first
        NotificationMailer.notify_about_practice(student, group, text).deliver!
        SmsNotifications.new.notify_about_practice!(group_subscription)
      end
    end
  end

  def notify_about_education_details
    date = Date.current.yesterday
    GroupSubscription.joins(:course).actual.where(sale_success_on: date.beginning_of_day..date.end_of_day,
                                                  courses: { short_name: GroupSubscription::COURSES_FOR_PROMOTION }).find_each do |subscription|
      NotificationMailer.education_details_notification(subscription).deliver!
    end
  end
end
