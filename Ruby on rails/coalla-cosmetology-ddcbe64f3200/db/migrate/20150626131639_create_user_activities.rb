class CreateUserActivities < ActiveRecord::Migration
  def change
    create_table :user_activities do |t|
      t.references :user, foreign_key: true
      t.index :user_id

      t.text :title, null: false
      t.text :description, null: false

      t.datetime :last_tracked_at, null: false
      t.integer :spent_time, null: false, default: 0

      t.index [:user_id, :title, :description], name: :user_activity_index
      t.index [:last_tracked_at]

      t.timestamps null: false
    end

    create_table :user_total_activities do |t|
      t.references :user, foreign_key: true
      t.index :user_id

      t.datetime :last_tracked_at, null: false
      t.integer :spent_time, null: false, default: 0
      t.integer :today_spent_time, null: false, default: 0

      t.timestamps null: false
    end
  end
end
