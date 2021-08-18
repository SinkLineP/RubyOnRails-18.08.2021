class CreateSkills < ActiveRecord::Migration
  def up
    create_table :skills do |t|
      t.text :name, null: false
      t.timestamps
    end
    add_index :skills, :name, unique: true
  end

  def down
    drop_table :skills
  end
end
