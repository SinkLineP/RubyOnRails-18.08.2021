# == Schema Information
#
# Table name: faqs
#
#  id         :integer          not null, primary key
#  question   :text
#  answer     :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  shop_id    :integer
#
# Indexes
#
#  index_faqs_on_shop_id  (shop_id)
#

class Faq < ActiveRecord::Base
  validates :question, :answer, presence: true

  scope :ordered, ->{ order(:created_at) }
end
