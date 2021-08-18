# == Schema Information
#
# Table name: categories
#
#  id         :integer          not null, primary key
#  name       :text
#  created_at :datetime
#  updated_at :datetime
#  shop_id    :integer
#
# Indexes
#
#  index_categories_on_shop_id  (shop_id)
#

class Category < ActiveRecord::Base
  has_many :blog_categories, inverse_of: :category, dependent: :destroy

  validates :name, presence: true

  scope :ordered, -> { order(:created_at) }
end
