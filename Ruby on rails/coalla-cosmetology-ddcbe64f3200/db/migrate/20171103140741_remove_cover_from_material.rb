class RemoveCoverFromMaterial < ActiveRecord::Migration
  def change
    remove_column :materials, :cover, :text
  end
end
