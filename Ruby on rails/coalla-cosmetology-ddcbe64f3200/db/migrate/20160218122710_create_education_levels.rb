class CreateEducationLevels < ActiveRecord::Migration
  def change
    create_table :education_levels do |t|
      t.text :title, null: false
      t.text :level, null: false

      t.timestamps null: false
    end
  end
end
