class CreateClassRooms < ActiveRecord::Migration
  def change
    create_table :class_rooms do |t|
      t.text :title, null: false

      t.timestamps null: false
    end
  end
end
