module ProgressHelper

  def display_all_passed_tasks
    total = current_user.all_passed_tasks
    [Russian.p(total, 'тест', 'теста', 'тестов'), Russian.p(total, 'задание', 'задания', 'заданий')].join(' и ')
  end

  def total_spent_hours
    spent_hours(current_user.user_total_activity.spent_time)
  end

  def total_spent_hours_title
    spent_hours_title(total_spent_hours)
  end

  def total_spent_minutes
    spent_minutes(current_user.user_total_activity.spent_time)
  end

  def total_spent_minutes_title
    spent_minutes_title(total_spent_minutes)
  end

  def today_spent_time_title
    display_total_time(current_user.user_total_activity.today_spent_time)
  end

  def display_total_time(seconds)
    time_title = []
    hours = spent_hours(seconds)
    minutes = spent_minutes(seconds)
    if hours > 0
      time_title << hours
      time_title << spent_hours_title(hours)
    end
    time_title << minutes
    time_title << spent_minutes_title(minutes)
    time_title.join(' ')
  end

  def spent_hours(spent_seconds)
    spent_seconds/3600
  end

  def spent_hours_title(spent_hours)
    Russian.p(spent_hours, 'час', 'часа', 'часов')
  end

  def spent_minutes(spent_seconds)
    spent_seconds%3600/60
  end

  def spent_minutes_title(spent_minutes)
    Russian.p(spent_minutes, 'минуту', 'минуты', 'минут')
  end

end
