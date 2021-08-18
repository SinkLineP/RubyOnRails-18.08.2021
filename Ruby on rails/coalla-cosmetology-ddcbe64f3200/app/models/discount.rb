# == Schema Information
#
# Table name: discounts
#
#  id         :integer          not null, primary key
#  title      :text
#  type       :text
#  value      :float            default(0.0), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  archival   :boolean          default(FALSE), not null
#

class Discount < ActiveRecord::Base
  has_many :group_subscriptions, inverse_of: :discount, dependent: :nullify
  has_many :linked_discounts, dependent: :destroy, foreign_key: :parent_id
  has_many :use_discounts, foreign_key: :discount_id, class_name: 'LinkedDiscount'
  has_many :discounts, through: :linked_discounts, source: :discount
  has_many :promo_codes, inverse_of: :discount
  has_many :automatic_discounts, inverse_of: :discount

  accepts_nested_attributes_for :linked_discounts, allow_destroy: true

  with_options presence: true do
    validates :title, :type
    validates :value,
              numericality: { greater_than: 0, allow_blank: true },
              unless: :composite?
  end
  validate :validate_linked_discounts, if: :composite?

  scope :simple, -> { where.not(type: 'CompositeDiscount') }
  scope :ordered, ->() { order(:created_at) }
  scope :active, ->() { where.not(archival: true) }

  def percent?
    is_a?(PercentDiscount)
  end

  def standard?
    is_a?(StandardDiscount)
  end

  def composite?
    is_a?(CompositeDiscount)
  end

  def cant_destroy?
    use_discounts.any? || group_subscriptions.any? || linked_discounts.any?
  end

  private

  def validate_linked_discounts
    current_linked_discounts = linked_discounts.select { |d| !d.marked_for_destruction? }
    errors.add(:base, 'Не заданы скидки') if current_linked_discounts.blank?
    errors.add(:base, 'Скидки должны быть уникальными') if current_linked_discounts.map(&:discount_id).uniq.count != current_linked_discounts.count
  end
end
