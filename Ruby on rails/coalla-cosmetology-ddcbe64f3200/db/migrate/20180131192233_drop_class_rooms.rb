class DropClassRooms < ActiveRecord::Migration
  def change
    drop_table :class_rooms do |t|
      t.text :title, null: false

      t.timestamps null: false
    end
  end
end
