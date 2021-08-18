class AddItemToUserActivity < ActiveRecord::Migration
  def change
    add_reference :user_activities, :trackable, polymorphic: true, index: true
  end
end
