class RenameAdminsToAdministrators < ActiveRecord::Migration
  def change
    ActiveRecord::Base.connection.execute("UPDATE users SET type = 'Administrator' WHERE type = 'Admin'")
  end
end
