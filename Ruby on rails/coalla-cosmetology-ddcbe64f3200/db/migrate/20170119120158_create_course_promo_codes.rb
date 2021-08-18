class CreateCoursePromoCodes < ActiveRecord::Migration
  def change
    create_table :course_promo_codes do |t|
      t.references :course, foreign_key: true, index: true
      t.references :promo_code, foreign_key: true, index: true
      t.integer :position, null: false, default: 0
      t.timestamps
    end
  end
end
