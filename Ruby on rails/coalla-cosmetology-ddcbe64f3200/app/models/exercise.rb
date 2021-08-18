# == Schema Information
#
# Table name: exercises
#
#  id         :integer          not null, primary key
#  text       :text
#  max_mark   :integer
#  index      :integer
#  work_id    :integer
#  parent_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_exercises_on_parent_id  (parent_id)
#  index_exercises_on_work_id    (work_id)
#

class Exercise < ActiveRecord::Base
  belongs_to :work, inverse_of: :exercises
  belongs_to :parent, class_name: :Exercise
  has_many :exercises, -> { order(:index) }, dependent: :destroy, foreign_key: :parent_id
  has_many :exercise_results, dependent: :nullify, inverse_of: :exercise

  accepts_nested_attributes_for :exercises, allow_destroy: true

  validates_presence_of :text
  validates_presence_of :max_mark, unless: :exercises
  validates_numericality_of :max_mark, only_integer: true, greater_than_or_equal_to: 0, allow_blank: true

  def with_sub_exercises?
    exercises.to_a.count > 0
  end
end
