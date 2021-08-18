# == Schema Information
#
# Table name: scans
#
#  id             :integer          not null, primary key
#  work_result_id :integer
#  file           :text
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_scans_on_work_result_id  (work_result_id)
#

class Scan < ActiveRecord::Base
  belongs_to :work_result, inverse_of: :scans

  mount_uploader :file, PrivateFileUploader

  def filename
    file.try(:file).try(:filename)
  end

  def extension
    file.try(:file).try(:extension)
  end
end
