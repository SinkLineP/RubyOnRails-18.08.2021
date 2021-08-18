class AddSeoFieldsToSpecialities < ActiveRecord::Migration
  def change
    add_column :specialities, :block1, :text
    add_column :specialities, :header2, :text
    add_column :specialities, :block2, :text
  end
end
