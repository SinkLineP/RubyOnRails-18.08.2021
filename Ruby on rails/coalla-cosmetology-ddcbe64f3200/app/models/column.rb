# == Schema Information
#
# Table name: columns
#
#  id         :integer          not null, primary key
#  title      :text
#  task_id    :integer
#  position   :integer
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_columns_on_task_id  (task_id)
#


class Column < ActiveRecord::Base
  include DeepDup

  belongs_to :task, inverse_of: :columns
  simple_acts_as_list scope: :task

  has_many :column_variants, -> { order(:position) }, inverse_of: :column, dependent: :destroy
  accepts_nested_attributes_for :column_variants, reject_if: ->(attributes){ attributes[:title].blank? }

  def column_variants_attributes=(column_variants_attributes)
    column_variants_attributes ||= []
    super
  end

  def deep_dup
    super(associations: [:column_variants])
  end

end
