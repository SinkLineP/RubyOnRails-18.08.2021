class AddPreviewFieldToMaterials < ActiveRecord::Migration
  def change
    add_column :materials, :preview, :text
    add_column :materials, :file_name, :text
  end
end
