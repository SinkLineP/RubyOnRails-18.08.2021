class AddSaleStageToSubscription < ActiveRecord::Migration
  def change
    drop_table :subscription_stages

    add_reference :group_subscriptions, :sale_stage, index: true, foreign_key: true
  end
end
