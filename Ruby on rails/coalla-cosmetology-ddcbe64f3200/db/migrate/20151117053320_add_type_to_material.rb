class AddTypeToMaterial < ActiveRecord::Migration
  def change
    add_column :materials, :type, :text
    Material.update_all(type: 'ScribdMaterial')
    change_column_null :materials, :type, false
  end
end
