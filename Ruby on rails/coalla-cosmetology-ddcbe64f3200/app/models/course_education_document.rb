# == Schema Information
#
# Table name: course_education_documents
#
#  id                    :integer          not null, primary key
#  education_document_id :integer
#  course_id             :integer
#  position              :integer          default(0), not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#
# Indexes
#
#  index_course_education_documents_on_course_id              (course_id)
#  index_course_education_documents_on_education_document_id  (education_document_id)
#  index_course_education_documents_on_position               (position)
#

class CourseEducationDocument < ActiveRecord::Base
  belongs_to :course, inverse_of: :course_education_documents
  belongs_to :education_document, inverse_of: :course_education_documents

  simple_acts_as_list scope: :course
end
