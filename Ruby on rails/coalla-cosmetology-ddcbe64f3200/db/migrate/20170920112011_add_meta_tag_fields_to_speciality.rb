class AddMetaTagFieldsToSpeciality < ActiveRecord::Migration
  def change
    add_column :specialities, :meta_description, :text
  end
end
