class AddWebinarLinkToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :webinar_link, :text
    add_column :groups, :webinar_notification_sent, :boolean, null: false, default: false
  end
end
