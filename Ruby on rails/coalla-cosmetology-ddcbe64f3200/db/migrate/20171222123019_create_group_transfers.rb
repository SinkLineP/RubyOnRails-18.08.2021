class CreateGroupTransfers < ActiveRecord::Migration
  def change
    create_table :group_transfers do |t|
      t.integer :new_group_id
      t.integer :old_group_id
      t.references :group_subscription, foreign_key: true
      t.timestamps null: false
    end
  end
end
