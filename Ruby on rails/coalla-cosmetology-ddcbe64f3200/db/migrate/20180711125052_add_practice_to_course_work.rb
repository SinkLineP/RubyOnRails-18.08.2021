class AddPracticeToCourseWork < ActiveRecord::Migration
  def change
    add_column :course_works, :practice, :boolean, null: false, default: false
  end
end
