# frozen_string_literal: true

module Routes
  class SdoConstraint
    def self.matches?(request)
      admin_subdomains = %w[sdo www.sdo]
      (1..3).map { |i| request.subdomain(i) }.any? do |subdomain|
        admin_subdomains.include?(subdomain)
      end
    end
  end
end
