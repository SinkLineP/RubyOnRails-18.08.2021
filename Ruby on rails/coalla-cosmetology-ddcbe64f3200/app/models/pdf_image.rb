# == Schema Information
#
# Table name: pdf_images
#
#  id            :integer          not null, primary key
#  imagable_id   :integer
#  imagable_type :string
#  image         :text
#  position      :integer          default(0), not null
#  integer       :integer          default(0), not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_pdf_images_on_imagable_type_and_imagable_id  (imagable_type,imagable_id)
#


class PdfImage < ActiveRecord::Base
  include DeepDup
  belongs_to :imagable, polymorphic: true

  mount_uploader :image, PdfImageUploader

  def deep_dup
    super(files: [:image])
  end
end
