class CreateWorkResults < ActiveRecord::Migration
  def change
    create_table :work_results do |t|
      t.references :group, index: true, foreign_key: true
      t.references :work, index: true, foreign_key: true
      t.date :marked_on
      t.text :scan

      t.timestamps null: false
    end
  end
end
