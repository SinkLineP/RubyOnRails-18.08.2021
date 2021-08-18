class AddDiplomaTitleToCourseDocuments < ActiveRecord::Migration
  def change
    remove_column :subscription_documents, :diploma_title
    add_column :course_documents, :diploma_title, :text
  end
end
