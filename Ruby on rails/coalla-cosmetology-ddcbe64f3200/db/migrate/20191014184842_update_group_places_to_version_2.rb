class UpdateGroupPlacesToVersion2 < ActiveRecord::Migration
  def change
    update_view :group_places, version: 2, revert_to_version: 1
  end
end
