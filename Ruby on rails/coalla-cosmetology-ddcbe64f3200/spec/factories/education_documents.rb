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

FactoryGirl.define do
  factory :education_document do
    title 'Диплом о профессиональной переподготовке'
    code 'retraining_diploma'
  end
end
