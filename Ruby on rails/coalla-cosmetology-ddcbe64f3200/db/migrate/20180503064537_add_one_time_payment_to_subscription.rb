class AddOneTimePaymentToSubscription < ActiveRecord::Migration
  def change
    add_column :group_subscriptions, :one_time_payment, :boolean, null: false, default: false
  end
end
