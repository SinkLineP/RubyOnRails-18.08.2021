# == Schema Information
#
# Table name: attachments
#
#  id         :integer          not null, primary key
#  item       :text
#  letter_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_attachments_on_letter_id  (letter_id)
#


class Attachment < ActiveRecord::Base
  belongs_to :letter, inverse_of: :attachments

  mount_uploader :item, FileUploader
end
