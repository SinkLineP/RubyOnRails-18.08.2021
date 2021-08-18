class AddTagsToCourseAndArticle < ActiveRecord::Migration
  def change
    add_column :courses, :tag_title, :text
    add_column :courses, :tag_description, :text
    add_column :articles, :tag_title, :text
    add_column :articles, :tag_description, :text
  end
end
