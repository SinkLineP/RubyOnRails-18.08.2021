module Schedule
  class Builder
    class << self
      def build
        groups_works = Schedule::GroupsWorksBuilder.new.build
        Schedule::GroupsWorksProcessor.new(groups_works).process
        Schedule::WorkingOffListsProcessor.new.process
        TableBuilder.new.build
        true
      end

      def reset
        ActiveRecord::Base.transaction do
          ScheduleItemGroup.delete_all
          ScheduleItemWorkingOffList.delete_all
          ScheduleItem.delete_all
          Group.update_all(scheduled: false)
          WorkingOffList.update_all(scheduled: false)
        end
        true
      end
    end
  end
end