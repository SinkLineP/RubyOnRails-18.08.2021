module MyStudentHelper

  def display_date_range(subscription)
    [
        format_subscription_date(subscription.begin_on),
        format_subscription_date(subscription.end_on)
    ].join(' - ')

  end

  def activity_type(activity)
    activity.title[0]
  end

  def full_activity_description(activity)
    return activity.description if activity.trackable.blank?

    item = activity.trackable
    result = "#{item.block.name}. #{activity_lecture_name(activity)}"
    if item.is_a?(Result)
      "#{result} #{item.task.display_name.mb_chars.capitalize}. #{activity.description}"
    else
      result
    end
  end

  def activity_name(activity)
    return activity.description if activity.trackable.blank?

    item = activity.trackable
    result = "#{item.block.name}. #{activity_lecture_name(activity)}"
    if item.is_a?(Result)
      "#{result} #{item.task.display_name.mb_chars.capitalize}."
    else
      result
    end
  end

  def activity_lecture_name(activity)
    item = activity.trackable
    "Лекция #{item.lecture_index}. #{item.description}"
  end

  def activity_task_type(activity)
    item = activity.trackable
    if item.is_a?(Result)
      item.task.display_name.mb_chars.capitalize
    else
      '-'
    end
  end

  def activity_result(activity)
    if activity.trackable.is_a?(Result)
      activity.description
    else
      '-'
    end
  end

  private

  def format_subscription_date(date)
    Russian::strftime(date, '%e %B')
  end

end