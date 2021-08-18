class AddPlacesOverNotifiedToGroup < ActiveRecord::Migration
  def change
    add_column :groups, :places_over_notified, :boolean, default: false, null: false
  end
end
