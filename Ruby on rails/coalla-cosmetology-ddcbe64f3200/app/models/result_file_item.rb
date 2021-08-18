# == Schema Information
#
# Table name: result_file_items
#
#  id         :integer          not null, primary key
#  file       :text
#  result_id  :integer
#  position   :integer
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_result_file_items_on_result_id  (result_id)
#


class ResultFileItem < ActiveRecord::Base
  include PositionSortable

  mount_uploader :file, FileUploader

  belongs_to :result_file, inverse_of: :result_file_items, foreign_key: :result_id

  def filename
    file.file.filename
  end
end
