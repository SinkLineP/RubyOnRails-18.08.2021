module Schedule
  class GroupsWorksProcessor
    include GroupDays

    def initialize(groups_works)
      @groups_works = groups_works.sort_by { |group_work| group_work.group.distances_place }.reverse
      @classrooms = Classroom.preload(:works).order(capacity: :desc)
      days = @groups_works.map(&:day).uniq
      @schedule_items = ScheduleItem.preload(schedule_item_groups: :group).where(day: days.min..days.max).to_a
    end

    def process
      @groups_works.group_by(&:group).each do |group, group_works|
        group_works = group_works.sort_by(&:begin_at)
        begin
          group_work = group_works.shift
          if @classrooms.none? { |classroom| classroom.works.include?(group_work.work) && classroom.capacity >= group_work.group.distances_place }
            logger.info("Couldn't found classroom for Group##{group.id} and Work##{group_work.work.id}")
            next
          end
          classroom = detect_classroom(group_work)
          if classroom
            @schedule_items << create_schedule_item!(group_work, classroom)
          else
            group_works.unshift(group_work)
            update_group_works_days(group_works)
          end
        end while group_works.present?
        group.update_columns(scheduled: true)
      end
      true
    end

    private

    def detect_classroom(group_work)
      @classrooms.detect do |possible_classroom|
        work_present = possible_classroom.works.include?(group_work.work)
        next unless work_present
        overlapped_item = @schedule_items.detect { |item| item.overlapped?(group_work) && item.classroom_id == possible_classroom.id }
        next if overlapped_item && !(overlapped_item.similar_datetime?(group_work) && overlapped_item.work_id == group_work.work.id && overlapped_item.work_index == group_work.work_index)
        reserved_places = overlapped_item.try(:places) || 0
        possible_classroom.capacity - reserved_places >= group_work.group.distances_place
      end
    end

    def create_schedule_item!(group_work, classroom)
      result = nil
      ScheduleItem.transaction do
        result = ScheduleItem.find_or_create_by!(work: group_work.work,
                                                 work_index: group_work.work_index,
                                                 classroom: classroom,
                                                 day: group_work.day,
                                                 begin_at: group_work.begin_at,
                                                 end_at: group_work.end_at)
        result.schedule_item_groups.create!(group: group_work.group)
      end
      result.reload
      result
    end

    def update_group_works_days(group_works)
      group_works.each_with_index do |group_work, index|
        next_group_work = group_works[index + 1]
        if next_group_work
          group_work.day = next_group_work.day
        else
          group_work.day = next_correct_day(group_work.group, group_work.day)
        end
      end
    end

    def logger
      @logger ||= ::Logger.new("#{Rails.root}/log/schedule.log")
    end
  end
end