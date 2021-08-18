module Documents
  module Common
    class ScheduleInfo
      include DocumentsHelper
      include ActionView::Helpers::NumberHelper

      def initialize(group_subscription)
        @group_subscription = group_subscription
      end

      def text
        group = @group_subscription.group

        if group.formatted_start_time == '00:00'
          return ''
        end

        if @group_subscription.practice == :practice
          return 'Индивидуально, согласно учебному плану программы.'
        end

        if @group_subscription.course_hours.to_i < Course.long_course_hours
          return group.practices.map { |practice| "#{practice.formatted_start_time}-#{practice.formatted_end_time} #{practice.begin_on == practice.end_on ? format_date_with_points(practice.begin_on) : format_date_with_points(practice.begin_on) + '-' + format_date_with_points(practice.end_on)}" }.join(";\s")
        end

        if group.schedule_description.present?
          return "#{group.schedule_description}#{practices_text(group)}"
        end

        result = "с #{group.formatted_start_time} до #{group.formatted_end_time}"

        if group.shift_work?
          result += "\r\nпо сменному графику 2/2 согласно расписанию занятий"
          return result + practices_text(group)
        end

        return result + practices_text(group) if group.week_days.blank?

        in_order = group.week_days.to_a.each_cons(2).all? { |pair| Group.week_days.values.index(pair.second.to_s) - Group.week_days.values.index(pair.first.to_s) == 1 }

        if in_order
          result += "\r\n#{group.week_days.to_a.first.text.mb_chars.downcase} - #{group.week_days.to_a.last.text.mb_chars.downcase}"
          return result + practices_text(group)
        end

        result + "\r\n#{group.week_days.map { |d| d.text.mb_chars.downcase }.join(', ')}" + practices_text(group)
      end

      private

      def practices_text(group)
        '' if group.practices.blank?
        "\r\nпрактика: " + group.practices.map { |practice| "#{practice.formatted_start_time}-#{practice.formatted_end_time} #{practice.begin_on == practice.end_on ? format_date_with_points(practice.begin_on) : format_date_with_points(practice.begin_on) + '-' + format_date_with_points(practice.end_on)}" }.join(";\s")
      end
    end
  end
end