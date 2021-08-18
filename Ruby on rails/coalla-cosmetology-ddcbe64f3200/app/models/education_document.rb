# == Schema Information
#
# Table name: education_documents
#
#  id          :integer          not null, primary key
#  title       :text             not null
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  code        :text             not null
#  builder     :string
#

class EducationDocument < ActiveRecord::Base
  has_many :course_documents, inverse_of: :education_document, dependent: :destroy
  has_many :subscription_documents, inverse_of: :education_document, dependent: :destroy
  has_many :pictures, inverse_of: :education_document, dependent: :destroy, class_name: :EducationDocumentPicture
  has_many :course_education_documents, dependent: :destroy, inverse_of: :education_document
  has_many :courses, ->{ uniq }, through: :course_education_documents

  validates_presence_of :title

  scope :ordered, ->() { order(:title) }
  scope :alphabetical_order, -> { order(:title) }

  accepts_nested_attributes_for :pictures, allow_destroy: true

  def builder_class
    return unless builder.presence
    "EducationDocuments::#{builder}".constantize
  end
end
