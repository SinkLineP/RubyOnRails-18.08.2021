# == Schema Information
#
# Table name: payment_requisites
#
#  id                    :integer          not null, primary key
#  group_subscription_id :integer
#  name                  :text
#  address               :text
#  inn                   :text
#  kpp                   :text
#  account               :text
#  bik                   :text
#  bank                  :text
#  correspondent_account :text
#  phone                 :text
#  email                 :text
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  position              :text
#  position_name         :text
#  legal_address         :text
#  position_genitive     :text
#  based                 :text
#
# Indexes
#
#  index_payment_requisites_on_group_subscription_id  (group_subscription_id)
#

class PaymentRequisite < ActiveRecord::Base
  belongs_to :group_subscription, inverse_of: :payment_requisite
end
