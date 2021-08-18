# frozen_string_literal: true

module Routes
  class OldUrlsConstraint
    def self.matches?(request)
      OldUrl.where(url: request.path).exists?
    end
  end
end
