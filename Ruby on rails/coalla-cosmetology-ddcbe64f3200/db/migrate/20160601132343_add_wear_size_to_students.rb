class AddWearSizeToStudents < ActiveRecord::Migration
  def change
    add_column :users, :wear_size, :text
  end
end
