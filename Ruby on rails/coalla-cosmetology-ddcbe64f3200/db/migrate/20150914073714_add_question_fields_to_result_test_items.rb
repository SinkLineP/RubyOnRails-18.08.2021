class AddQuestionFieldsToResultTestItems < ActiveRecord::Migration
  def change
    add_column :result_test_items, :question_title, :text
    add_column :result_test_items, :question_answer_title, :text
    add_column :result_test_items, :correct_answer_title, :text

    ResultTestItem.find_each do |result_test_item|
      result_test_item.question_title = result_test_item.question.try(:title)
      result_test_item.question_answer_title = result_test_item.question_answer.try(:title)
      result_test_item.correct_answer_title = result_test_item.question.try(:correct_answer).try(:title)
      result_test_item.save!
    end
  end
end
