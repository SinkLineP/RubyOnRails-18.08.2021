class ExpulsionNotifications
  def self.run
    GroupSubscription.with_long_courses
        .actual
        .not_expelled
        .not_academic_vacation
        .where(end_on: Date.current).find_each do |subscription|
      next if subscription.group.practices.present? || subscription.not_passed_lectures.blank?

      subscription.build_expulsion_notification.generate!
      NotificationMailer.notify_about_poor_progress_expulsion(subscription).deliver!
    end
  end
end