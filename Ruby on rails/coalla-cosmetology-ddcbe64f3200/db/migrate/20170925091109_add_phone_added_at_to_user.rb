class AddPhoneAddedAtToUser < ActiveRecord::Migration
  def up
    add_column :users, :phone_added_at, :datetime
    User.where('array_length(phones, 1) > 0').update_all(phone_added_at: Time.current)
  end

  def down
    remove_column :users, :phone_added_at
  end
end
