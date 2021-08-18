class CreateCourseAutomaticDiscounts < ActiveRecord::Migration
  def change
    create_table :course_automatic_discounts do |t|
      t.references :course, foreign_key: true, index: true
      t.references :automatic_discount, foreign_key: true, index: true
      t.integer :position, null: false, default: 0
      t.timestamps
    end
  end
end
