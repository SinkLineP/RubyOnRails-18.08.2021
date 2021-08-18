# == Schema Information
#
# Table name: course_documents
#
#  id                    :integer          not null, primary key
#  course_id             :integer
#  education_level_id    :integer
#  education_document_id :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  academic_hours        :integer
#  program_name          :text
#  diploma_title         :text
#
# Indexes
#
#  index_course_documents_on_course_id              (course_id)
#  index_course_documents_on_education_document_id  (education_document_id)
#  index_course_documents_on_education_level_id     (education_level_id)
#

class CourseDocument < ActiveRecord::Base
  belongs_to :course, inverse_of: :course_documents
  belongs_to :education_level, inverse_of: :course_documents
  belongs_to :education_document, inverse_of: :course_documents

  delegate :title, to: :education_document
  delegate :title, to: :education_level, prefix: true

  validates :education_document_id, presence: true
end
