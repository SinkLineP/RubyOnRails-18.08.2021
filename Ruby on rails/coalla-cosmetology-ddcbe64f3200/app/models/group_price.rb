# == Schema Information
#
# Table name: group_prices
#
#  id                      :integer          not null, primary key
#  amount                  :integer          default(0), not null
#  payments_text           :text             not null
#  group_id                :integer
#  created_at              :datetime
#  updated_at              :datetime
#  education_form_id       :integer
#  early_booking           :boolean          default(FALSE)
#  bank_installment        :boolean          default(FALSE)
#  bank_installment_months :integer          default(0)
#
# Indexes
#
#  index_group_prices_on_education_form_id  (education_form_id)
#  index_group_prices_on_group_id           (group_id)
#

class GroupPrice < ActiveRecord::Base
  PAYMENT_TEXT_SEPARATOR = ';'

  belongs_to :group, inverse_of: :prices
  belongs_to :education_form, inverse_of: :group_prices
  has_many :all_group_subscriptions, -> { with_deleted }, class_name: :GroupSubscription, dependent: :nullify
  has_many :group_subscriptions, dependent: :nullify, inverse_of: :group_price

  with_options(presence: true) do
    validates :group
    validates :payments_text
  end
  validates :amount, :bank_installment_months, numericality: {greater_than_or_equal_to: 0}
  validate :check_sum_payments

  scope :ordered, ->() { order("CASE WHEN position(';' in payments_text)>0 THEN 1 ELSE 0 END ",:amount) }
  scope :with_education_form, ->(education_form_id) { where(education_form_id: education_form_id) }

  def display_text
    "#{amount} (#{payments_text})"
  end

  def amo_display_text
    options = []
    options << 'раннее бронирование' if early_booking?
    options << 'рассрочка от банка' if bank_installment?
    "#{amount} (#{payments_text}) #{options.join(', ')}"
  end

  def cost
    one_time_payment? ? amount : payment_amounts.first
  end

  def payment_amounts
    return [] unless payments_text.present?

    payments_text.split(PAYMENT_TEXT_SEPARATOR).map(&:to_f)
  end

  def payments_total_amount
    payment_amounts.sum
  end

  def one_time_payment_with_early_booking?
    one_time_payment? && early_booking?
  end

  def one_time_payment?
    payment_amounts.count == 1
  end

  def expired?
    Date.current > (group.nearest_education_day - 3.months)
  end

  private

  def check_sum_payments
    errors.add(:payments_total_amount, :not_equal_total_amount) if amount != payments_total_amount
  end
end
