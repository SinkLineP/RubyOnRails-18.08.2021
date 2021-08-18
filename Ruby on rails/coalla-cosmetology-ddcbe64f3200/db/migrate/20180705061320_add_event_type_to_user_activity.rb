class AddEventTypeToUserActivity < ActiveRecord::Migration
  def change
    add_column :user_activities, :event_type, :text, null: false, default: 'learning'
  end
end
