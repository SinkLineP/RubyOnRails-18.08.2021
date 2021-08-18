class Date
  def each_month(end_on)
    dt = self
    begin
      yield dt
      dt = dt.next_month
    end while dt <= end_on
  end
end

Date::DATE_FORMATS[:default] = '%d.%m.%Y'