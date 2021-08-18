class AddSubscriptionFieldToUser < ActiveRecord::Migration
  def change
    add_column :users, :subscribed_on_blog, :boolean, default: false
  end
end
