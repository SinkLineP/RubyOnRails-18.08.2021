class AddBadgeToCourse < ActiveRecord::Migration
  def change
    add_column :courses, :badge, :text
  end
end
