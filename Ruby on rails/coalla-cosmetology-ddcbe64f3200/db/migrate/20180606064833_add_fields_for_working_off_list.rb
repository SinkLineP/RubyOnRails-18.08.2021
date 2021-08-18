class AddFieldsForWorkingOffList < ActiveRecord::Migration
  def change
    add_column :working_off_lists, :working_off_type, :text, default: 'not_chosen'
    add_column :working_off_lists, :exam, :boolean, null: false, default: false
    add_reference :working_off_lists, :instructor, index: true
    add_foreign_key :working_off_lists, :users, column: :instructor_id
  end
end
