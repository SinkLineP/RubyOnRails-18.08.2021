module Schedule
  class WorkingOffListsProcessor
    def initialize
      @lists = WorkingOffList.where('processed_on > ?', Date.current).where(scheduled: false)
    end

    def process
      @lists.each do |list|
        schedule_item = ScheduleItem.preload(:classroom).where('schedule_items.day >= ?', list.processed_on).where(work_id: list.work_id).detect do |item|
          item.places + 1 <= item.classroom.capacity
        end
        next unless schedule_item
        ScheduleItem.transaction do
          schedule_item.schedule_item_working_off_lists.create!(working_off_list: list)
          list.update_columns(scheduled: true)
        end
      end
    end
  end
end