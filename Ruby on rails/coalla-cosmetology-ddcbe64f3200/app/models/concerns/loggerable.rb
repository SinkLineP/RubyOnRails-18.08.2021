# frozen_string_literal: true

module Loggerable
  extend ActiveSupport::Concern

  included do
    has_many :logs, as: :loggerable
  end
end
