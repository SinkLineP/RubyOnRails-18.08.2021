# == Schema Information
#
# Table name: notice_attachments
#
#  id         :integer          not null, primary key
#  notice_id  :integer
#  file       :text
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_notice_attachments_on_notice_id  (notice_id)
#

class NoticeAttachment < ActiveRecord::Base
  belongs_to :notice, inverse_of: :notice_attachments

  mount_uploader :file, FileUploader

  def filename
    file.try(:file).try(:filename)
  end

  def extension
    file.try(:file).try(:extension)
  end
end
