class AddRatingFieldsForSubscription < ActiveRecord::Migration
  def change
    add_column :group_subscriptions, :rating_place, :integer, default: 0
    add_column :group_subscriptions, :rating_score, :integer, default: 0
  end
end
