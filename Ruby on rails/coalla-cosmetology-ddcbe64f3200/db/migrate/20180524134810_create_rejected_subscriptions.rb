class CreateRejectedSubscriptions < ActiveRecord::Migration
  def change
    create_table :rejected_subscriptions do |t|
      t.references :user, foreign_key: true, index: true, null: false
      t.text :notification_type, index: true, null: false
      t.timestamps null: false
    end
  end
end
