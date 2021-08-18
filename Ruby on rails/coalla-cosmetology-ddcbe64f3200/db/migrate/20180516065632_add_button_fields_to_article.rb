class AddButtonFieldsToArticle < ActiveRecord::Migration
  def change
    add_column :articles, :button_text, :text
    add_column :articles, :button_link, :text
  end
end
