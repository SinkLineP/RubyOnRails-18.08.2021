# == Schema Information
#
# Table name: cosmetology_procedures
#
#  id         :integer          not null, primary key
#  name       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  shop_id    :integer
#
# Indexes
#
#  index_cosmetology_procedures_on_shop_id  (shop_id)
#

class CosmetologyProcedure < ActiveRecord::Base
  validates :name, presence: true

  has_many :procedure_requests, inverse_of: :cosmetology_procedure, dependent: :nullify

  scope :ordered, -> { order(:created_at) }
end
