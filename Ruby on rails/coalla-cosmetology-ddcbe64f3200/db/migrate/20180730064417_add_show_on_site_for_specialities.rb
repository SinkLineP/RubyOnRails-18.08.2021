class AddShowOnSiteForSpecialities < ActiveRecord::Migration
  def change
    add_column :specialities, :show_on_site, :boolean, default: true, null: false
  end
end
