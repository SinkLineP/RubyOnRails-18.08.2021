class InstituteBreakNotification
  def initialize
    @student_emails = GroupSubscription.joins(:practices).preload(:student)
                  .actual
                  .not_expelled
                  .not_expired
                  .where('(practices.begin_on BETWEEN :start AND :end) OR (practices.end_on BETWEEN :start AND :end) OR (practices.begin_on < :start AND practices.end_on > :end)', start: Date.new(2020, 3, 31), end: Date.new(2020, 5, 1))
                  .map { |subscription| subscription.student.email }
                  .uniq
  end

  def run
    @student_emails.each do |email|
      NotificationMailer.institute_break_notify(email).deliver!
    end
  end
end