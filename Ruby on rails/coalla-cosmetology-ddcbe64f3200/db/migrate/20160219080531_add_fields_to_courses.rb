class AddFieldsToCourses < ActiveRecord::Migration
  def change
    change_table :courses do |t|
      t.text :short_name
      t.integer :hours, null: false, default: 0
      t.references :faculty, index: true, foreign_key: true
    end
  end
end
