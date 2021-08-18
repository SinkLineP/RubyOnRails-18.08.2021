class CreateAmoModuleCourses < ActiveRecord::Migration
  def change
    create_table :amo_module_courses do |t|
      t.references :course, foreign_key: true, index: true
      t.references :amo_module, foreign_key: true, index: true
      t.integer :position, null: false, default: 0
      t.timestamps null: false
    end
  end
end
