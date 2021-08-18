class AddWelcomeSentAtToUsers < ActiveRecord::Migration
  def change
    add_column :users, :welcome_sent_at, :datetime

    Student.find_each do |student|
      student.update_columns(welcome_sent_at: Time.current) if student.can_sign_in?
    end
  end
end
