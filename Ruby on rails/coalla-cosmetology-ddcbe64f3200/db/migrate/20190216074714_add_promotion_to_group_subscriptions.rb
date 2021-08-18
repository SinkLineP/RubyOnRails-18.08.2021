class AddPromotionToGroupSubscriptions < ActiveRecord::Migration
  def change
    add_reference :group_subscriptions, :promotion, index: true, foreign_key: true
    add_column :group_subscriptions, :promotion_source, :text
  end
end
