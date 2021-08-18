class AddSecretPasswordToBook < ActiveRecord::Migration
  def change
    add_column :books, :secret_password, :text
  end
end
