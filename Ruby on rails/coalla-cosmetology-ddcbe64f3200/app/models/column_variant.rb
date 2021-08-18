# == Schema Information
#
# Table name: column_variants
#
#  id         :integer          not null, primary key
#  title      :text
#  column_id  :integer
#  position   :integer
#  created_at :datetime
#  updated_at :datetime
#  image      :text
#
# Indexes
#
#  index_column_variants_on_column_id  (column_id)
#

class ColumnVariant < ActiveRecord::Base
  belongs_to :column, inverse_of: :column_variants
  simple_acts_as_list scope: :column

  mount_uploader :image, ColumnVariantImageUploader

end
