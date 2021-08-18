# == Schema Information
#
# Table name: promo_codes
#
#  id           :integer          not null, primary key
#  code         :text
#  discount_id  :integer
#  end_date     :date
#  reusable     :boolean          default(FALSE)
#  extinguished :boolean          default(FALSE)
#  created_at   :datetime
#  updated_at   :datetime
#
# Indexes
#
#  index_promo_codes_on_discount_id  (discount_id)
#

class PromoCode < ActiveRecord::Base

  has_many :course_promo_codes, inverse_of: :promo_code, dependent: :destroy
  has_many :orders, inverse_of: :promo_code, dependent: :nullify
  has_many :courses, through: :course_promo_codes
  belongs_to :discount, inverse_of: :promo_codes

  scope :ordered, -> { order(:created_at) }

  validates :code, :discount_id, presence: true

  def active?
    enabled? && !expired?
  end

  def inactive?
    !active?
  end

  def expired?
    Date.current > end_date if end_date
  end

  def enabled?
    reusable? || !extinguished?
  end

  def self.generate_code
    chars = ('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a
    code = ''
    6.times{ code += chars[rand()*chars.length]}
    code
  end

end
