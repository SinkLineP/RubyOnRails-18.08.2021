class CreateFaculties < ActiveRecord::Migration
  def change
    create_table :faculties do |t|
      t.text :title, null: false

      t.timestamps null: false
    end
  end
end
