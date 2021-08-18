class CreateGroupSubscriptions < ActiveRecord::Migration
  def change
    create_table :group_subscriptions do |t|
      t.references :student
      t.foreign_key :users, column: :student_id
      t.references :group
      t.foreign_key :groups
      t.date :begin_on
      t.date :end_on

      t.timestamps null: false
    end
  end
end
