# == Schema Information
#
# Table name: magazine_payment_types
#
#  id         :integer          not null, primary key
#  title      :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class MagazinePaymentType < ActiveRecord::Base
  has_many :payment_logs, dependent: :nullify

  validates :title, presence: true

  scope :ordered, ->{ order(:title) }
end
