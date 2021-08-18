# == Schema Information
#
# Table name: education_levels
#
#  id                      :integer          not null, primary key
#  title                   :text             not null
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  education_document_name :text
#

class EducationLevel < ActiveRecord::Base
  has_many :course_documents, inverse_of: :education_level, dependent: :nullify
  has_many :users, inverse_of: :education_level, dependent: :nullify

  validates_presence_of :title

  scope :ordered, ->() { order(:title) }
end
