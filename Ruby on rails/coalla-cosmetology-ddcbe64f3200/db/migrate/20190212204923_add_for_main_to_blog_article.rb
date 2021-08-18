class AddForMainToBlogArticle < ActiveRecord::Migration
  def change
    add_column :articles, :for_main, :boolean, null: false, default: false
  end
end
