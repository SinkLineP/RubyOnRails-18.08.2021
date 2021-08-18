class RemoveLevelFromEducationLevel < ActiveRecord::Migration
  def change
    remove_column :education_levels, :level, :text
  end
end
