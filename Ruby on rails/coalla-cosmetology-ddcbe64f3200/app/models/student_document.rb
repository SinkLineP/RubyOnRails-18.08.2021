# == Schema Information
#
# Table name: student_documents
#
#  id             :integer          not null, primary key
#  title          :text
#  document_type  :text
#  file           :text
#  user_id        :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  loaded_by_user :boolean          default(FALSE)
#
# Indexes
#
#  index_student_documents_on_user_id  (user_id)
#

class StudentDocument < ActiveRecord::Base
  extend Enumerize

  belongs_to :user, inverse_of: :student_documents

  enumerize :document_type, in: [:other_document, :passport, :photo, :health_insurance, :medical_license, :name_change_certificate], default: :other_document, predicates: true, scope: true

  mount_uploader :file, PrivateFileUploader

  validates :file, presence: true, if: :loaded_by_user

  before_save do
    self.title = nil unless other_document?
  end

  def title_text
    title.presence || document_type_text
  end

  def filename
    file.try(:file).try(:filename)
  end
end
