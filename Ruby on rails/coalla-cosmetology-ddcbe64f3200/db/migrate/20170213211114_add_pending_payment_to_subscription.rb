class AddPendingPaymentToSubscription < ActiveRecord::Migration
  def change
    add_column :group_subscriptions, :pending_payment_at, :datetime
  end
end
