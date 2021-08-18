module PositionSortable
  extend ActiveSupport::Concern

  included do
    scope :ordered, -> { order(:position) }

    before_create do
      self.position = (self.class.maximum(:position) || 0) + 1 if position.blank? || position == 0
    end
  end
end