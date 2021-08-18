class CreateGraduateFaculties < ActiveRecord::Migration
  def change
    create_table :graduate_faculties do |t|
      t.references :graduate, index: true, foreign_key: true
      t.references :faculty, index: true, foreign_key: true
      t.integer :position, null: false, default: 0
      t.timestamps
    end
  end
end
