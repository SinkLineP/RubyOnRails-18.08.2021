# == Schema Information
#
# Table name: downloads
#
#  id         :integer          not null, primary key
#  file       :text
#  lecture_id :integer
#  position   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_downloads_on_lecture_id               (lecture_id)
#  index_downloads_on_lecture_id_and_position  (lecture_id,position)
#


class Download < ActiveRecord::Base
  include DeepDup

  mount_uploader :file, DownloadFileUploader

  belongs_to :lecture, inverse_of: :downloads

  simple_acts_as_list scope: :lecture

  def url=(_value)
  end

  def url
    file_url
  end

  def filename=(_value)
  end

  def filename
    file.file.filename if file && file.file
  end

  def extension=(_value)
  end

  def extension
    file.file.extension.upcase if file && file.file
  end

  def cache=(value)
    return if value.blank?
    self.file_cache = value
    file_will_change!
  end

  def cache
    file_cache
  end

  def deep_dup
    super(files: [:file])
  end

end
