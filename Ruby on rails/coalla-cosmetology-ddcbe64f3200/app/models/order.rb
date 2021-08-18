# frozen_string_literal: true

# == Schema Information
#
# Table name: orders
#
#  id            :integer          not null, primary key
#  user_id       :integer
#  promo_code_id :integer
#  created_at    :datetime
#  updated_at    :datetime
#  status        :text
#  cart          :boolean          default(FALSE)
#  full          :boolean          default(FALSE)
#  payment_type  :string
#  shop_id       :integer
#
# Indexes
#
#  index_orders_on_promo_code_id  (promo_code_id)
#  index_orders_on_shop_id        (shop_id)
#  index_orders_on_user_id        (user_id)
#

class Order < ActiveRecord::Base
  extend Enumerize

  belongs_to :user, inverse_of: :orders
  belongs_to :promo_code, inverse_of: :orders
  belongs_to :automatic_discount, inverse_of: :orders
  has_many :order_group_subscriptions, inverse_of: :order, dependent: :destroy
  has_many :group_subscriptions, through: :order_group_subscriptions
  has_many :group_prices, through: :group_subscriptions
  has_many :courses, through: :group_subscriptions
  has_many :payment_logs, -> { ordered }, dependent: :nullify, inverse_of: :order
  has_many :generated_documents, as: :item
  has_one :payment_receipt, as: :item, dependent: :destroy
  has_one :order_contract, as: :item, dependent: :destroy
  has_one :multiple_questionnaire, as: :item, dependent: :destroy
  has_many :cash_receipts, as: :item, dependent: :nullify

  accepts_nested_attributes_for :group_subscriptions

  enumerize :status, in: [:pending_payment, :paid], default: :pending_payment, predicates: true
  enumerize :payment_type, in: [:bank, :bank_tkb, :cash, :receipt, :terminal], default: :cash, predicates: true

  scope :ordered, -> { order(created_at: :desc) }
  scope :in_cart, -> { where(cart: true).ordered }

  define_method "group_subscription_ids=" do |item_ids|
    item_ids = item_ids || []
    item_ids.each_with_index do |id, index|
      send("order_group_subscriptions").find_by("group_subscription_id" => id).try(:update_column, :position, index + 1)
    end
    super(item_ids)
  end

  def amount
    payment_logs.sum(:amount)
  end

  def current_course_ids
    current_group_subscriptions.map { |s| s.course.id }
  end

  def full_price_with_discount
    if paid?
      return amount
    end
    current_group_subscriptions.sum { |s| s.payment_amount(self) }
  end

  def full_price
    current_group_subscriptions.sum(&:price)
  end

  def discount_sum
    current_group_subscriptions.sum(&:discount_amount)
  end

  def current_group_subscriptions
    order_group_subscriptions.map(&:group_subscription)
  end

  def discounts
    discounts = current_group_subscriptions.map { |s| s.discount }
    (discounts << promo_code.try(:discount)).reject(&:blank?).uniq
  end

  def generate_payment_receipt!
    (payment_receipt || build_payment_receipt).generate!
  end

  def not_zero_subscriptions
    zero_subscription_ids = group_subscriptions.select(&:zero_price_with_installment?).map(&:id)
    group_subscriptions.where.not(id: zero_subscription_ids)
  end

  def payment_params
    {
      orderid: id,
      clientid: user.email,
      sum: full_price_with_discount.to_i,
      phone: user.phone.to_s
    }
  end

  def generate_documents!
    with_lock do
      (order_contract || build_order_contract).generate!
      group_subscriptions.each do |subscription|
        (subscription.questionnaire || subscription.build_questionnaire).generate!
      end
      (multiple_questionnaire || build_multiple_questionnaire).generate!
    end
  end

  def first_subscription
    order_group_subscriptions.order_by_position.first.group_subscription
  end

  def order_subscription?
    order_group_subscriptions.first.present?
  end

  def zero_price?
    full_price_with_discount.zero?
  end
end
