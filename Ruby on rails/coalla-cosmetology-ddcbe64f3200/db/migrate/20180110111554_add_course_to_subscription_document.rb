class AddCourseToSubscriptionDocument < ActiveRecord::Migration
  def change
    add_reference :subscription_documents, :course, index: true, foreign_key: true
  end
end
