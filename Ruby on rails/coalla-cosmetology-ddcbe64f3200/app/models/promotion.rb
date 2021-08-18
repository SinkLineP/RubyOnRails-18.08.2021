# == Schema Information
#
# Table name: promotions
#
#  id         :integer          not null, primary key
#  title      :text
#  announce   :text
#  image      :text
#  link       :text
#  visible    :boolean
#  created_at :datetime
#  updated_at :datetime
#  shop_id    :integer
#
# Indexes
#
#  index_promotions_on_shop_id  (shop_id)
#

class Promotion < ActiveRecord::Base
  has_many :group_subscriptions, inverse_of: :promotion, dependent: :nullify

  mount_uploader :image, PromotionImageUploader

  validates :title, :announce, :image, presence: true

  scope :ordered, -> { order(:created_at) }
  scope :ordered_desc, -> { order(created_at: :desc) }
  scope :ordered_visible, -> { order(visible: :desc).ordered }
  scope :visible, -> { where(visible: true) }

  def feed_id
    id + 5000
  end

  def display_name
    "(#{visible ? 'А' : 'Н'}) #{title}"
  end

end
