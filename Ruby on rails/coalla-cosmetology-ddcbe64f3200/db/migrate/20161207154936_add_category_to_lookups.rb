class AddCategoryToLookups < ActiveRecord::Migration
  def change
    add_column :lookups, :category, :string
  end
end
