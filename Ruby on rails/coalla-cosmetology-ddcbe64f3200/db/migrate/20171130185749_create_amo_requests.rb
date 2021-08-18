class CreateAmoRequests < ActiveRecord::Migration
  def change
    create_table :amo_requests do |t|
      t.string :method, null: false
      t.text :url, null: false
      t.text :params, null: false
      t.float :timeout, null: false

      t.timestamps null: false
      t.index :created_at
    end
  end
end
