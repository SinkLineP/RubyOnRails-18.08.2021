class CreateAnotherGroupPlaces < ActiveRecord::Migration
  def change
    create_view :another_group_places
  end
end
