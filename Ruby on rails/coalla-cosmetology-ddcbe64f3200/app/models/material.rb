# == Schema Information
#
# Table name: materials
#
#  id         :integer          not null, primary key
#  lecture_id :integer
#  name       :text
#  time       :integer
#  link       :text
#  required   :boolean          default(FALSE), not null
#  position   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  preview    :text
#  file_name  :text
#  type       :text             not null
#  pdf        :text
#  pdf_status :text
#
# Indexes
#
#  index_materials_on_lecture_id  (lecture_id)
#  index_materials_on_position    (position)
#

class Material < ActiveRecord::Base
  extend Enumerize
  include DeepDup
  include Pdf

  FILTERED_ATTRIBUTES = %w(pdf_filename pdf_extension pdf_editable cover_file_url cover_file_name)

  mount_uploader :preview, MaterialPreviewUploader

  belongs_to :lecture, inverse_of: :materials
  has_many :finished_materials, inverse_of: :material, dependent: :destroy

  simple_acts_as_list scope: :lecture

  def deep_dup
    self.skip_job = true
    super(files: [:preview, :pdf], associations: [{pdf_images: :imagable_id}])
  end

  def scribd?
    is_a?(ScribdMaterial)
  end

  def pdf?
    is_a?(PdfMaterial)
  end
end
