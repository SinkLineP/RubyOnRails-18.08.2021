# frozen_string_literal: true

module Routes
  class AdminConstraint
    def self.matches?(request)
      admin_subdomains = %w[admin www.admin]
      (1..3).map { |i| request.subdomain(i) }.any? do |subdomain|
        admin_subdomains.include?(subdomain)
      end
    end
  end
end
