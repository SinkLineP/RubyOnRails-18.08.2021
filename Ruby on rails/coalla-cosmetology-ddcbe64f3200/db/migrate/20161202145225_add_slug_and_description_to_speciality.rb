class AddSlugAndDescriptionToSpeciality < ActiveRecord::Migration
  def change
    add_column :specialities, :slug, :text
    add_column :specialities, :announcement, :text
  end
end
