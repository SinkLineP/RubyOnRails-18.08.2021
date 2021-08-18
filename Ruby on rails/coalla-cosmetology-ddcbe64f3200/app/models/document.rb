# == Schema Information
#
# Table name: documents
#
#  id                  :integer          not null, primary key
#  file                :text
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  document_section_id :integer
#
# Indexes
#
#  index_documents_on_document_section_id  (document_section_id)
#  index_documents_on_file                 (file)
#

class Document < ActiveRecord::Base

  belongs_to :document_section, inverse_of: :documents

  mount_uploader :file, FileUploader

  scope :ordered, -> { order(:file) }

  def filename
    file.file.try(:filename).to_s
  end

  def extension
    file.file.try(:extension).to_s
  end

end
