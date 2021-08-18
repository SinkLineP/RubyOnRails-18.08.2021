class ChangeAuthenticationUrlNull < ActiveRecord::Migration
  def change
    change_column_null :authentications, :url, true
  end
end
