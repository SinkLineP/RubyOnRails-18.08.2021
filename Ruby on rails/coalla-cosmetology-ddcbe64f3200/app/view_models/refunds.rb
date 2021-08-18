class Refunds
  REGISTRATION_FEE = 10000

  attr_reader :expulsions

  def initialize(expulsions)
    @expulsions = expulsions
  end

  def calculate
    group = expulsions.first.group
    group_subscriptions = GroupSubscription.where(student_id: expulsions.flat_map(&:expelled_students).map(&:student_id),
                                                  group_id: group.id)

    expulsions.flat_map do |expulsion|
      expulsion.expelled_students.map do |expelled_student|
        group_subscription = group_subscriptions.detect { |gs| gs.group_id == group.id && gs.student_id == expelled_student.student_id }

        next unless group_subscription
        course_remote_price = group_subscription.offline? ? 0 : group.course_remote_price

        payed = PaymentLog.where(student_id: expelled_student.student_id, group_id: group.id).sum(:amount) || 0
        passed_hours_price = group.course_hours == 0 ? 0 : (group_subscription.price / group.course_hours) * expelled_student.hours
        refund = payed - REGISTRATION_FEE - passed_hours_price - course_remote_price

        OpenStruct.new(
            student_full_name: expelled_student.full_name,
            group_title: group.title,
            course_name: group.course_name,
            expelled_on: expulsion.expelled_on,
            payed: payed,
            registration_fee: REGISTRATION_FEE,
            course_hours: group.course_hours,
            price: group_subscription.price,
            passed_hours: expelled_student.hours,
            passed_hours_price: passed_hours_price,
            refund: refund,
            remote_price: course_remote_price
        )
      end
    end.compact
  end
end