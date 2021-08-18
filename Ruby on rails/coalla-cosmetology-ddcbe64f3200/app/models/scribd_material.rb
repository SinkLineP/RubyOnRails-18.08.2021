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

class ScribdMaterial < Material
  def cover_file_url
    preview_url(:thumb)
  end

  def cover_file_name
    preview.file.filename if preview && preview.file
  end

  def cover_cache
    preview_cache
  end

  def cover_cache=(value)
    return if value.blank?
    self.preview_cache = value
    preview_will_change!
  end
end
