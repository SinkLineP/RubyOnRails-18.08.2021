# == Schema Information
#
# Table name: document_sections
#
#  id         :integer          not null, primary key
#  title      :text             not null
#  created_at :datetime
#  updated_at :datetime
#

class DocumentSection < ActiveRecord::Base
  has_many :documents, dependent: :nullify, inverse_of: :document_section

  scope :alphabetical_order, -> { order(:title) }
  scope :ordered, -> { order(:created_at) }
end
