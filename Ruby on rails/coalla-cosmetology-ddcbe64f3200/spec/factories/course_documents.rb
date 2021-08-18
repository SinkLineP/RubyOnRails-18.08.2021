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

FactoryGirl.define do
  factory :course_document do
    association :course
    association :education_document
    education_level_id { EducationLevel.pluck(:id).sample }
  end
end
