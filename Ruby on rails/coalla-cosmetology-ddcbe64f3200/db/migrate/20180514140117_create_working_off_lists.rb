class CreateWorkingOffLists < ActiveRecord::Migration
  def change
    create_table :working_off_lists do |t|
      t.text :hours, null: false
      t.text :variant, null: false
      t.text :user_file
      t.date :processed_on, null: false
      t.references :work, foreign_key: true, index: true
      t.references :group_subscription, foreign_key: true, index: true
      t.timestamp
    end
  end
end
