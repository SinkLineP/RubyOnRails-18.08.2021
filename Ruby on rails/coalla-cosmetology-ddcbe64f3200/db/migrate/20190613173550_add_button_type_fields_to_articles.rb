class AddButtonTypeFieldsToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :button_type, :string
  end
end
