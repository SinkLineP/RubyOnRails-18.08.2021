module GroupExtensions
  include ApplicationHelper

  def all_practice_periods_text(delimiter = ";\s")
    self.practices.map { |practice| "в #{practice.formatted_start_time}-#{practice.formatted_end_time} c #{format_date(practice.begin_on)} до #{format_date(practice.end_on)}" }.join(delimiter)
  end

  def all_practice_dates_text
    self.practices.map { |practice| "#{practice.formatted_start_time}-#{practice.formatted_end_time}"}.join(";\s")
  end

  def all_practice_times_text
    self.practices.map { |practice| "c #{format_date(practice.begin_on)} до #{format_date(practice.end_on)}"}.join(";\s")
  end

end