module TimeFormatHelper

  def format_datetime(date, format = '%d.%m.%Y')
    return unless date
    date.strftime(format)
  end

end