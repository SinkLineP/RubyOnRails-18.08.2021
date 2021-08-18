# == Schema Information
#
# Table name: document_copies
#
#  id             :integer          not null, primary key
#  file           :text
#  item_id        :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  item_type      :text             not null
#  loaded_by_user :boolean          default(FALSE)
#
# Indexes
#
#  index_document_copies_on_item_id  (item_id)
#

class DocumentCopy < ActiveRecord::Base
  belongs_to :user, inverse_of: :document_copies

  mount_uploader :file, PrivateFileUploader

  validates :file, presence: true, if: :loaded_by_user

  def filename
    file.try(:file).try(:filename)
  end

  def extension
    file.try(:file).try(:extension)
  end
end
