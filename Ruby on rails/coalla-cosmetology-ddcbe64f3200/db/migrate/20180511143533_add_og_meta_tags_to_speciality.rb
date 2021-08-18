class AddOgMetaTagsToSpeciality < ActiveRecord::Migration
  def change
    add_column :specialities, :meta_og_title, :text
    add_column :specialities, :meta_og_description, :text
  end
end
