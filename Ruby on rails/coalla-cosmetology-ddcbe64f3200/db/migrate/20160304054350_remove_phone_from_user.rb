class RemovePhoneFromUser < ActiveRecord::Migration
  def up
    # User.where.not(phone: nil).find_each do |user|
    #   user.update_column(:phones, [user.phone.gsub(/\+/, '')])
    # end
    #
    # remove_column :users, :phone
  end

  def down
    add_column :users, :phone, :text
  end
end
