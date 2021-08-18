# == Schema Information
#
# Table name: partners
#
#  id          :integer          not null, primary key
#  image       :text             not null
#  title       :text             not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  description :text
#  shop_id     :integer
#  url         :string
#
# Indexes
#
#  index_partners_on_shop_id  (shop_id)
#

class Partner < ActiveRecord::Base
  mount_uploader :image, PartnerImageUploader

  validates :image, :title, presence: true
  validates :url, format: URI::regexp(%w[http https])

  scope :ordered, -> { order(:created_at) }
end
