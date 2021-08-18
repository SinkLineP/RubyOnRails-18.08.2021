module UsedTimesHelper
  def time_select_options(used_time, skip_all_day = false)
    result = UsedTime.possible_times(used_time.date).map do |time|
      formatted_time = Russian.strftime(time, '%H:%M')
      [formatted_time, formatted_time]
    end

    if used_time.persisted?
      result << [used_time.formatted_time, used_time.formatted_time]
      result = result.sort
    end

    if UsedTime.can_use_all_day?(used_time.date, used_time) && !skip_all_day
      [['весь день', nil]] + result
    else
      result
    end
  end
end