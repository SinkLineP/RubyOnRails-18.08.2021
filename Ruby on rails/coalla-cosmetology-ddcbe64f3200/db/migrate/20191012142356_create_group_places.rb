class CreateGroupPlaces < ActiveRecord::Migration
  def change
    create_view :group_places
  end
end
