# == Schema Information
#
# Table name: history_events
#
#  id          :integer          not null, primary key
#  title       :text
#  year        :text
#  description :text
#  image       :text
#  position    :integer          default(0), not null
#  created_at  :datetime
#  updated_at  :datetime
#  shop_id     :integer
#
# Indexes
#
#  index_history_events_on_shop_id  (shop_id)
#

class HistoryEvent < ActiveRecord::Base
  include PositionSortable

  mount_uploader :image, HistoryEventImageUploader

  validates :title, :year, :description, :image, presence: true

  scope :ordered, -> { order(:position) }
end
