class ChangePracticeDatetimeToDateFields < ActiveRecord::Migration
  def up
    change_column :practices, :begin_on, :date
    change_column :practices, :end_on, :date
    Practice.find_each do |practice|
      practice.begin_on += 1.day
      practice.end_on += 1.day
      practice.save!
    end
  end

  def down
    change_column :practices, :begin_on, :datetime
    change_column :practices, :end_on, :datetime
  end
end
