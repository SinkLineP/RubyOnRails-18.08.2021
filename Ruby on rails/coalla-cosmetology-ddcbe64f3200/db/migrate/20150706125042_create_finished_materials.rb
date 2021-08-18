class CreateFinishedMaterials < ActiveRecord::Migration
  def change
    create_table :finished_materials do |t|
      t.references :student, index: true
      t.foreign_key :users, column: :student_id
      t.references :material, index: true
      t.foreign_key :materials
      t.index [:student_id, :material_id], unique: true

      t.timestamps null: false
    end
  end
end
