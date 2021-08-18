module GroupSubscriptions
  class RelocationNotifier
    def run
      load_students.each do |student|
        begin
          NotificationMailer.institute_relocation_notification(student).deliver!
        rescue
        end
      end
    end

    def load_students
      incorrect_groups_ids = Practice.joins(:group).where('practices.end_on IS NOT NULL AND practices.end_on >= ?', Date.new(2018, 9, 10)).group('groups.id').select('groups.id')
      incorrect_student_ids = GroupSubscription.actual.where(group_id: incorrect_groups_ids).pluck(:student_id).uniq
      correct_student_ids = GroupSubscription.actual.where.not(group_id: incorrect_groups_ids).pluck(:student_id).uniq
      Student.where(id: correct_student_ids - incorrect_student_ids)
    end
  end
end