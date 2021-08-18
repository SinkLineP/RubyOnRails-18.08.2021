class AddAppointmentToCourse < ActiveRecord::Migration
  def change
    add_column :courses, :appointment, :text
    Course.update_all(appointment: :additional_education)
    change_column_null :courses, :appointment, false
  end
end
