# == Schema Information
#
# Table name: education_document_pictures
#
#  id                    :integer          not null, primary key
#  education_document_id :integer
#  image                 :text
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#
# Indexes
#
#  index_education_document_pictures_on_education_document_id  (education_document_id)
#

class EducationDocumentPicture < ActiveRecord::Base
  belongs_to :education_document, inverse_of: :pictures

  mount_uploader :image, EducationDocumentImageUploader

  def filename
    image.try(:file).try(:filename)
  end

  def extension
    image.try(:file).try(:extension)
  end
end
