# == Schema Information
#
# Table name: payment_logs
#
#  id                       :integer          not null, primary key
#  payed_on                 :date
#  amount                   :float
#  payment_type             :text
#  appointment              :text
#  comment                  :text
#  group_id                 :integer
#  student_id               :integer
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  order_id                 :integer
#  magazine_payment_type_id :integer
#
# Indexes
#
#  index_payment_logs_on_group_id                  (group_id)
#  index_payment_logs_on_magazine_payment_type_id  (magazine_payment_type_id)
#  index_payment_logs_on_order_id                  (order_id)
#  index_payment_logs_on_student_id                (student_id)
#

class PaymentLog < ActiveRecord::Base
  extend Enumerize

  belongs_to :group, inverse_of: :payment_logs
  belongs_to :student, inverse_of: :payment_logs
  belongs_to :order, inverse_of: :payment_logs
  belongs_to :magazine_payment_type, inverse_of: :payment_logs

  enumerize :payment_type, in: %i(cash bank site terminal_mkb terminal_uralsib credit gift_certificate receipt), default: :cash, predicates: true
  enumerize :appointment, in: %i(education extraordinary magazine), default: :education, predicates: true

  delegate :title, to: :group, allow_nil: true, prefix: true
  delegate :full_name, to: :student, allow_nil: true, prefix: true

  scope :ordered, -> { order(created_at: :desc) }

  validates_presence_of :amount, :payed_on
  validates_numericality_of :amount, allow_blank: true
  validates_presence_of :group_id, if: :education?
  validates_presence_of :comment, if: :extraordinary?
  validates_presence_of :magazine_payment_type_id, if: :magazine?

  before_validation do
    if education?
      self.comment = nil
      self.magazine_payment_type_id = nil
    elsif extraordinary?
      self.group_id = nil
      self.magazine_payment_type_id = nil
    else
      self.group_id = nil
      self.comment = nil
    end
  end

  def group_subscription
    @group_subscription ||= GroupSubscription.find_by(student_id: student_id, group_id: group_id)
  end

  def method_text
    return '' if extraordinary? || !group_subscription
    if group_subscription.price == amount
      'Единовременно'
    else
      'Рассрочка'
    end
  end

  def prepayment
    return '' if !group_subscription
    if group_subscription.end_on.strftime("%Y:%m") > payed_on.strftime("%Y:%m")
      'аванс'
    else
      ''
    end
  end

  def month_of_profit
    return '' if !group_subscription
    group_subscription.end_on.strftime("%m / %Y")
  end

  def reason_for_payment
    magazine? ? magazine_payment_type.try(:title) : comment
  end
end
