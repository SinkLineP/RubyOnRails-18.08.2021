module GroupsHelper

  DAYS = {monday: 'пн', tuesday: 'вт', wednesday: 'ср', thursday: 'чт', friday: 'пт', saturday: 'сб', sunday: 'вс'}

  def group_period(group)
    [content_tag(:time, format_date_st(group.begin_on), datetime: ''), content_tag(:time, format_date_st(group.end_on), datetime: '')].join('&mdash;').html_safe
  end

  def education_schedule(group, with_mdash_if_no_data = true, output_of_all_practice_dates = false, blank_out = '&mdash;')
    return blank_out.html_safe unless group
    return blank_out.html_safe if group.fake
    data = []
    data << if group.schedule_type.shift_work?
              '2/2'
            else
              range = DAYS.map { |day, abbr| abbr if group.week_days.include?(day) }
              range = range.split(nil)
              range.map { |b| [b[0], b[-1]].uniq.join('-') if b.any? }
            end
    if group.education_times.present?
      if output_of_all_practice_dates
        data << group.practices.map{|practice| [practice_date(practice.begin_on, practice.end_on), practice_time(practice.start_time, practice.end_time)].join(', ')}.join('<br>')
      else
        data << practice_time(group.education_times.first, group.education_times.last)
      end
    end
    result = data.flatten.compact.join(', ')

    if result.blank? && with_mdash_if_no_data
      blank_out.html_safe
    else
      result
    end
  end

  def education_schedule_alt(group)
    return '&mdash;'.html_safe unless group
    return '&mdash;'.html_safe if group.fake
    data = []
    data << if group.schedule_type.shift_work?
              '2/2'
            else
              range = DAYS.map { |day, abbr| abbr if group.week_days.include?(day) }
              range = range.split(nil)
              range.map { |b| [b[0], b[-1]].uniq.join('-') if b.any? }
            end
    if group.practices.any?
     data << group.practices.map{|practice| [practice_date(practice.begin_on, practice.end_on), practice_time(practice.start_time, practice.end_time)].join(', ')}.join('<br>')
    else
     data << practice_time(group.education_times.first, group.education_times.last)
    end

    data.flatten.compact.join(', ')
  end

  def free_places_text(group)
    return '&mdash;'.html_safe unless group
    return '—'.html_safe if group.fake
    count = group.free_places
    "Осталось #{places_text(count)}".html_safe
  end

  def practice_date(begin_on, end_on)
    begin_on == end_on ? Russian.strftime(begin_on, '%d.%m') : [Russian.strftime(begin_on, '%d.%m'), Russian.strftime(end_on, '%d.%m')].join('-')
  end

  def practice_time(start_time, end_time)
    "c #{format_time(start_time)} до #{format_time(end_time)}"
  end

  def places_text(count)
    "#{count}&nbsp;#{Russian.p(count, 'место', 'места', 'мест')}".html_safe
  end

  def education_period(group)
    return '&mdash;'.html_safe unless group
    return 'Хочу учиться, но не выбрал дату' if group.fake
    group.education_dates.map { |date| format_date_short(date) }.join(' &mdash; ').html_safe
  end

  def education_period_short(group)
    return '&mdash;'.html_safe unless group
    group.education_dates.map { |date| month_year_format(date) }.join(' &mdash; ').html_safe
  end

  def education_period_short_with_schedule(group)
    return '&mdash;'.html_safe unless group
    return 'Хочу учиться, но не выбрал дату'.html_safe if group.fake

    schedule = education_schedule(group, false)
    if schedule.present?
      "#{education_period_short(group)} (#{schedule})".html_safe
    else
      education_period_short(group)
    end
  end
end
