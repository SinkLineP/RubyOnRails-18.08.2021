module Holidays
  class Import
    WORK_DAY_TYPES = [2, 3]

    def initialize(year)
      @year = year
    end

    def run
      weekends = (Date.new(@year, 1, 1)..Date.new(@year, 12, 31)).select { |date| date.saturday? || date.sunday? }
      holidays = load_holidays
      workdays = load_workdays
      (weekends.reject { |day| workdays.include?(day) } + holidays).uniq.sort.each do |day|
        Holiday.find_or_create_by!(day: day)
      end
    end

    private

    def load_holidays
      data = load_xmlcalendar_data
      data.select { |item| WORK_DAY_TYPES.exclude?(item.t) }.map { |item| item_to_date(item) }
    end

    def load_workdays
      data = load_xmlcalendar_data
      data.select { |item| WORK_DAY_TYPES.include?(item.t) }.map { |item| item_to_date(item) }
    end

    def load_xmlcalendar_data
      @xmlcalendar_data ||= begin
        request_body = HTTParty.get("http://xmlcalendar.ru/data/ru/#{@year}/calendar.xml").body
        parsed_data = Hash.from_xml(request_body)['calendar']['days'].values[0]
        parsed_data.map { |item| OpenStruct.new(item) }
      end
    end

    def item_to_date(item)
      month, day = item.d.split('.')
      Date.new(@year, month.to_i, day.to_i)
    end
  end
end