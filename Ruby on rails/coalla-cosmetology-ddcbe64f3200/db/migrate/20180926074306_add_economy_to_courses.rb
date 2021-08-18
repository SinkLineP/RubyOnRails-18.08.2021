class AddEconomyToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :economy_for_several, :float
    add_column :courses, :economy_description, :text
  end
end
