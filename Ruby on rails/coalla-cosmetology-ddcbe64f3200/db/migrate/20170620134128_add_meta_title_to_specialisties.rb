class AddMetaTitleToSpecialisties < ActiveRecord::Migration
  def change
    add_column :specialities, :meta_title, :text
  end
end
