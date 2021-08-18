# == Schema Information
#
# Table name: procedure_requests
#
#  id                       :integer          not null, primary key
#  name                     :text
#  email                    :string
#  phone                    :string
#  cosmetology_procedure_id :integer
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#
# Indexes
#
#  index_procedure_requests_on_cosmetology_procedure_id  (cosmetology_procedure_id)
#

class ProcedureRequest < ActiveRecord::Base
  belongs_to :cosmetology_procedure, inverse_of: :procedure_requests

  validates :name, :email, :phone, :cosmetology_procedure_id, presence: true

  delegate :name, to: :cosmetology_procedure, allow_nil: true, prefix: :procedure
end
