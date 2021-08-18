# == Schema Information
#
# Table name: result_test_items
#
#  id                    :integer          not null, primary key
#  result_id             :integer
#  question_answer_id    :integer
#  created_at            :datetime
#  updated_at            :datetime
#  question_id           :integer
#  question_title        :text
#  question_answer_title :text
#  correct_answer_title  :text
#
# Indexes
#
#  index_result_test_items_on_question_answer_id  (question_answer_id)
#  index_result_test_items_on_question_id         (question_id)
#  index_result_test_items_on_result_id           (result_id)
#

class ResultTestItem < ActiveRecord::Base
  belongs_to :result_test, inverse_of: :result_test_items, foreign_key: :result_id
  belongs_to :question_answer
  belongs_to :question

  delegate :correct?, to: :question_answer, allow_nil: true

  validates_presence_of :question_answer_id

  before_create do
    self.question_title = question.try(:title)
    self.question_answer_title = question_answer.try(:title)
    self.correct_answer_title = question.try(:correct_answer).try(:title)
  end
end
