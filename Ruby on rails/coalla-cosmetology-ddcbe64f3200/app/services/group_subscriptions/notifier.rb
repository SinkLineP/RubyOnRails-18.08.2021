# frozen_string_literal: true

module GroupSubscriptions
  class Notifier
    def initialize(group_subscription)
      @group_subscription = group_subscription
      @student = @group_subscription.student
      @group = @group_subscription.group
      @course = @group_subscription.course
    end

    def notify!
      return if @group_subscription.disabled_send?
      send_welcome_mail!
      notify_without_welcome!
    end

    def notify_without_welcome!
      return if @group_subscription.disabled_send?
      notify_about_first_lecture
      send_practice_notifications
    end

    private

    def send_welcome_mail!
      if student.welcome_sent?
        CosmetologyMailer.notify_about_new_courses(student, group_subscription).deliver!
        return
      end

      password = Devise.friendly_token(8)
      student.update!(password: password, welcome_sent_at: Time.current)
      CosmetologyMailer.sign_up(student, group_subscription).deliver!
    end

    def notify_about_first_lecture
      can_notify = course.long? &&
          (Date.current..Date.current + 3.days).include?(group.academic_on) &&
          group_subscription.education_form == EducationForm.offline
      return unless can_notify

      NotificationMailer.notify_about_lecture(student, group_subscription, "До первой лекции меньше трех дней!").deliver!
      SmsNotifications.new.notify_about_lecture!(group_subscription)
    end

    def send_practice_notifications
      practice = group.practices.try(:first)
      return unless practice

      if group.first_practice_after_days?(5, true) && course.short?
        NotificationMailer.notify_before_first_practice(student).deliver!
      end

      if group.first_practice_after_days?(14, true) && course.long?
        NotificationMailer.notify_practice_access(student).deliver!
      end

      if course.long? && (Date.current..Date.current + 3.days).include?(practice.begin_on)
        NotificationMailer.notify_about_practice(student, group, "До первого практического занятия меньше трех дней!").deliver!
        SmsNotifications.new.notify_about_practice!(group_subscription)
      end
    end

    attr_reader :group_subscription, :student, :group, :course
  end
end
