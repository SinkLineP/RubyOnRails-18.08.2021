# == Schema Information
#
# Table name: institution_blocks
#
#  id         :integer          not null, primary key
#  code       :text
#  video_url  :text
#  content    :text
#  link       :text
#  link_title :text
#  created_at :datetime
#  updated_at :datetime
#

class InstitutionBlock < ActiveRecord::Base
  include WithUploadedVideo

  has_many :institution_images, -> { order(:position) }, inverse_of: :institution_block, dependent: :destroy
  accepts_nested_attributes_for :institution_images, allow_destroy: true

  with_uploaded_video

  validates :code, presence: true

  scope :ordered, -> { order(:created_at) }
end
