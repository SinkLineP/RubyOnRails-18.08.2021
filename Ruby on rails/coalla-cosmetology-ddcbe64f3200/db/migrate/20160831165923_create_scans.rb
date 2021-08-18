class CreateScans < ActiveRecord::Migration
  def change
    create_table :scans do |t|
      t.references :work_result, index: true, foreign_key: true

      t.text :file

      t.timestamps null: false
    end
  end
end
