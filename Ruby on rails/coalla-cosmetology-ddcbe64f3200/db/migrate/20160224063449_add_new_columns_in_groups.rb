class AddNewColumnsInGroups < ActiveRecord::Migration
  def change
    add_column :groups, :start_time, :time, null: false, default: '09:00:00'
    add_column :groups, :end_time, :time, null: false, default: '13:00:00'
    add_column :groups, :academic_on, :datetime
    add_column :groups, :schedule_type, :text, null: false, default: 'specific_days' # shift work
    add_column :groups, :shift_work_on, :datetime
    add_column :groups, :schedule_description, :text
    add_column :groups, :itec, :text
  end
end
