class AddEmailPasswordToUsers < ActiveRecord::Migration
  def change
    add_column :users, :encrypted_email_password, :text
  end
end
