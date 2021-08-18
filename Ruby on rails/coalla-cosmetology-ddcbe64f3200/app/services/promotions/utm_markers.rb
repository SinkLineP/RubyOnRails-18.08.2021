module Promotions
  class UtmMarkers
    MARKERS = %w(utm_source utm_medium utm_campaign utm_content utm_term)

    attr_reader :params, :cookies

    def initialize(params, cookies)
      @params = params
      @cookies = cookies
    end

    def save
      markers = select_markers(params)
      markers.each { |key, value| cookies[key] = value }
    end

    def load
      select_markers(cookies).to_h
    end

    private

    def select_markers(data)
      data.select { |key, _value| MARKERS.include?(key.to_s) }
    end
  end
end