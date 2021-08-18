# == Schema Information
#
# Table name: question_answers
#
#  id          :integer          not null, primary key
#  title       :text
#  question_id :integer
#  position    :integer
#  created_at  :datetime
#  updated_at  :datetime
#
# Indexes
#
#  index_question_answers_on_question_id  (question_id)
#

class QuestionAnswer < ActiveRecord::Base
  belongs_to :question, inverse_of: :question_answers
  simple_acts_as_list scope: :question

  has_many :result_test_items, dependent: :nullify

  def correct?
    position == 1
  end

end
