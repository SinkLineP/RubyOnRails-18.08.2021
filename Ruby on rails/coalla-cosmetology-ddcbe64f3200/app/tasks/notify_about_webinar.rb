class NotifyAboutWebinar
  TIMEZONE_DIFFERENCE = 3.hours
  NOTIFICATION_PERIOD = 1.hour

  def self.run
    NotifyAboutWebinar.new.run
  end

  def run
    start_time = Time.current + TIMEZONE_DIFFERENCE
    end_time = start_time + NOTIFICATION_PERIOD
    Group.where.not(webinar_link: nil)
         .where(webinar_notification_sent: false)
         .where(begin_on: Date.current)
         .where('start_time BETWEEN :start AND :end', start: start_time, end: end_time).find_each do |group|
      next if group.webinar_link.blank?

      group.amo_success_students.find_each do |student|
        NotificationMailer.notify_about_webinar(student, group.webinar_link).deliver
        SmsNotifications.new.notify_about_webinar!(student, group.webinar_link)
      end
      group.update_columns(webinar_notification_sent: true)
    end
  end
end