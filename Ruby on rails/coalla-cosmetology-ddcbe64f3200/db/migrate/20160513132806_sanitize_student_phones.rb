class SanitizeStudentPhones < ActiveRecord::Migration
  def up
    if column_exists? :users, :phone
      remove_column :users, :phone
    end

    Student.find_each do |s|
      s.update_columns(phones: s.sanitized_phones)
    end
  end

  def down
  end
end
