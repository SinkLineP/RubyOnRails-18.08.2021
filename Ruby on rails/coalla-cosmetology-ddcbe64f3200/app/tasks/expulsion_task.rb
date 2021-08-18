class ExpulsionTask

  def self.run
    Group.where('end_on::date = ?', Date.current).each do |group|
      expulsion = group.expulsions.build(expelled_on: Date.current, personal: false, non_attendance: false, expulsion_order_attributes: {created_on: Date.current})
      group.subscriptions.actual.not_expelled.not_academic_vacation.not_created_from_module.each do |subscription|
        expulsion.expelled_students << ExpelledStudent.new(hours: group.course.hours, student: subscription.student)
      end
      expulsion.save
    end
  end

end