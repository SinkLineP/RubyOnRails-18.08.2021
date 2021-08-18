class RequisitesNotification
  def initialize
    @students = GroupSubscription.preload(:student)
                  .actual
                  .not_expelled
                  .not_expired
                  .select { |subscription| !subscription.paid? }
                  .map(&:student)
                  .uniq
  end

  def run
    @students.each do |student|
      NotificationMailer.requisites_changed(student).deliver!
    end
  end
end