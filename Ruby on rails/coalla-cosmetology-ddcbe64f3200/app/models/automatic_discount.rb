# == Schema Information
#
# Table name: automatic_discounts
#
#  id          :integer          not null, primary key
#  name        :text
#  discount_id :integer
#  enabled     :boolean          default(FALSE)
#  created_at  :datetime
#  updated_at  :datetime
#
# Indexes
#
#  index_automatic_discounts_on_discount_id  (discount_id)
#

class AutomaticDiscount < ActiveRecord::Base

  has_many :course_automatic_discounts, inverse_of: :automatic_discount, dependent: :destroy
  has_many :courses, through: :course_automatic_discounts
  has_many :orders, inverse_of: :automatic_discount, dependent: :nullify
  belongs_to :discount, inverse_of: :automatic_discounts

  validates :name, :discount_id, :courses, presence: true

  scope :ordered, -> { order(:created_at) }
  scope :enabled, -> { where(enabled: true) }

  def course_names
    courses.map(&:short_name).reject(&:blank?).join(', ')
  end
end
