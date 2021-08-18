class ChangeAcademicOnTimestampToDate < ActiveRecord::Migration
  def up
    change_column :groups, :academic_on, :date
    Group.find_each do |group|
      if group.academic_on
        group.academic_on += 1.day
        group.save!
      end
    end
  end

  def down
    change_column :groups, :academic_on, :datetime
  end
end
