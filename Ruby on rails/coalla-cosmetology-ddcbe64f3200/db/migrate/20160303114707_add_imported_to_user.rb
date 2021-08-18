class AddImportedToUser < ActiveRecord::Migration
  def change
    add_column :users, :imported_from_amo, :boolean, null: false, default: false
  end
end
