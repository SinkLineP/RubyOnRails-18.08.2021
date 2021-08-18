class AddQuestionToResultTestItem < ActiveRecord::Migration
  def change
    add_reference :result_test_items, :question, index: true
    add_foreign_key :result_test_items, :questions
  end
end
