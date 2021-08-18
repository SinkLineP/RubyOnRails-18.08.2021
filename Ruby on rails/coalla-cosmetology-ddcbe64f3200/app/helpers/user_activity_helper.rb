module UserActivityHelper

  def display_activity_total_time(student, course)
    since = student.group_subscription_for_course(course).try(:created_at)
    to = student.group_subscription_for_course(course).try(:to)
    total_time = student.user_activities_for_course(course, since, to).sum(&:spent_time)
    display_total_time(total_time)
  end

  def display_activity_spent_time(activity)
    display_activity_time(activity.spent_time)
  end

  def display_activity_time(activity_time)
    hours = activity_time / 3600
    hours_text = hours > 0 ? hours.to_s : nil

    minutes = (activity_time % 3600) / 60
    minutes_text = hours > 0 ? format_activity_item(minutes) : minutes.to_s

    seconds = activity_time % 60
    seconds_text = format_activity_item(seconds)

    [hours_text, minutes_text, seconds_text].compact.join(':')
  end

  def display_activity_date(activity)
    activity_date = activity.last_tracked_at.to_date
    if activity_date.today?
      'сегодня'
    elsif (activity_date + 1.day).today?
      'вчера'
    else
      format_date(activity_date)
    end
  end

  private

  def format_activity_item(item)
    item.to_s.rjust(2, '0')
  end

end
