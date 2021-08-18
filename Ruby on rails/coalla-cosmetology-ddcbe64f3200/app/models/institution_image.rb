# == Schema Information
#
# Table name: institution_images
#
#  id                   :integer          not null, primary key
#  image                :text
#  name                 :text
#  institution_block_id :integer
#  position             :integer          default(0), not null
#  created_at           :datetime
#  updated_at           :datetime
#
# Indexes
#
#  index_institution_images_on_institution_block_id  (institution_block_id)
#

class InstitutionImage < ActiveRecord::Base

  include PositionSortable

  validates :image, :name, presence: true

  belongs_to :institution_block, inverse_of: :institution_images

  mount_uploader :image, InstitutionImageUploader

  scope :ordered, -> { order(:created_at) }

end
