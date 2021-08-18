# == Schema Information
#
# Table name: uploaded_videos
#
#  id            :integer          not null, primary key
#  title         :text             not null
#  preview_image :text
#  file          :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  jw_script     :text
#

class UploadedVideo < ActiveRecord::Base

  mount_uploader :file, FileUploader
  mount_uploader :preview_image, UploadedVideoPreviewImageUploader

  has_many :item_videos, inverse_of: :uploaded_video, dependent: :destroy

  with_options presence: true do
    validates :title, :preview_image
  end

  scope :ordered, -> { order(created_at: :desc) }

end
