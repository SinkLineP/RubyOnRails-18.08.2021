class CreateSubscriptionStages < ActiveRecord::Migration
  def change
    create_table :subscription_stages do |t|
      t.date :stage_changed_on
      t.references :group_subscription, null: false, default: 0
      t.references :sale_stage, null: false, default: 0

      t.timestamps null: false
    end
  end
end
