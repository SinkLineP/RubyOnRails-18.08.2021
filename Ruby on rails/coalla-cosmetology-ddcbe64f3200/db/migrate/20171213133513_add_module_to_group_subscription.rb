class AddModuleToGroupSubscription < ActiveRecord::Migration
  def change
    add_reference :group_subscriptions, :amo_module, foreign_key: true, index: true
  end
end
