class CreateCourseSeos < ActiveRecord::Migration
  def change
    create_table :course_seos do |t|
      t.references :course, index: true, foreign_key: true
      t.string :place
      t.text :content

      t.timestamps null: false
    end
    add_index :course_seos, :place
  end
end
