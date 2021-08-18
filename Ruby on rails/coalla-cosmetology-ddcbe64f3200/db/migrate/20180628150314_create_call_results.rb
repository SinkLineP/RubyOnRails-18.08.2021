class CreateCallResults < ActiveRecord::Migration
  def change
    create_table :call_results do |t|
      t.string :status
      t.references :group_subscription, index: true, foreign_key: true
      t.integer :duration
      t.string :code
      t.string :user_input
      t.boolean :processed, null: false, default: false

      t.timestamps null: false
    end
  end
end
