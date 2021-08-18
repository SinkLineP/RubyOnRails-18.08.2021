class CreateClassrooms < ActiveRecord::Migration
  def change
    create_table :classrooms do |t|
      t.text :title, null: false
      t.integer :capacity, null: false, default: 0
      t.integer :external_id

      t.timestamps null: false
    end
  end
end
