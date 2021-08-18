# == Schema Information
#
# Table name: result_connection_items
#
#  id                :integer          not null, primary key
#  result_id         :integer
#  column_id         :integer
#  column_variant_id :integer
#  created_at        :datetime
#  updated_at        :datetime
#
# Indexes
#
#  index_result_connection_items_on_column_id          (column_id)
#  index_result_connection_items_on_column_variant_id  (column_variant_id)
#  index_result_connection_items_on_result_id          (result_id)
#


class ResultConnectionItem < ActiveRecord::Base
  belongs_to :result_connection, inverse_of: :result_connection_items, foreign_key: :result_id
  belongs_to :column
  belongs_to :column_variant

  delegate :time_expired?, to: :result_connection

  validates_presence_of :column_id, :column_variant_id, unless: :time_expired?

  def correct?
    column == column_variant.column
  end
end
