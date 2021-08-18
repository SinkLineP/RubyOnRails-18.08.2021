class CreateSimilarCourses < ActiveRecord::Migration
  def change
    create_table :similar_courses do |t|
      t.references :similar, index: true
      t.foreign_key :courses, column: :similar_id
      t.references :course, index: true, foreign_key: true
      t.integer :position, null: false, default: 0, index: true

      t.timestamps null: false
    end
  end
end
