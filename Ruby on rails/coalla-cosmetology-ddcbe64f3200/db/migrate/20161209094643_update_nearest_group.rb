class UpdateNearestGroup < ActiveRecord::Migration
  def up
    Course.find_each do |c|
      c.change_nearest_group
    end
  end

  def down
    Course.update_all(nearest_group_id: nil, nearest_education_day: nil)
  end
end
