class AddCategoryToSaleStage < ActiveRecord::Migration
  def change
    add_column :sale_stages, :category, :text
  end
end
