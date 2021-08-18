# == Schema Information
#
# Table name: questions
#
#  id         :integer          not null, primary key
#  title      :text
#  image      :text
#  task_id    :integer
#  position   :integer
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_questions_on_task_id  (task_id)
#


class Question < ActiveRecord::Base
  include DeepDup

  belongs_to :task, inverse_of: :questions
  simple_acts_as_list scope: :task

  mount_uploader :image, QuestionImageUploader

  has_many :question_answers, -> { order(:position) }, inverse_of: :question, dependent: :destroy
  accepts_nested_attributes_for :question_answers

  has_many :result_test_items, dependent: :nullify

  attr_accessor :for_edit

  def random_answers
    question_answers.unscope(:order).order('RANDOM()')
  end

  def question_answers_attributes=(question_answers_attributes)
    question_answers_attributes ||= []
    super
  end

  def correct_answer
    question_answers.first
  end

  def image_name=(args)
  end

  def image_name
    image.file.filename if image && image.file
  end

  def deep_dup
    super(associations: [:question_answers], files: [:image])
  end

end
