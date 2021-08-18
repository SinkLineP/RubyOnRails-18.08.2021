class UrlUtils
  class << self
    def add_params(url, params)
      params = params.deep_dup
      return url if params.blank?
      url = url.chomp('/')
      link_part, query_part = url.split('?')
      if query_part
        query_part = query_part.delete('/')
        query_part_params = Rack::Utils.parse_nested_query(query_part)
        params.deep_merge!(query_part_params)
      end
      "#{link_part}?#{params.to_query}"
    end
  end
end