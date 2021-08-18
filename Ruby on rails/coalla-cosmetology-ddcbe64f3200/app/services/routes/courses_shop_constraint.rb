# frozen_string_literal: true

module Routes
  class CoursesShopConstraint
    def self.matches?(request)
      host = request.host.gsub("www.", "")
      Shop.all.map(&:domain).include?(host) && !(AdminConstraint.matches?(request) || SdoConstraint.matches?(request))
    end
  end
end
