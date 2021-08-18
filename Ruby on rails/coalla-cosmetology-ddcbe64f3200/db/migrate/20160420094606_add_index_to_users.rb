class AddIndexToUsers < ActiveRecord::Migration
  def change
    add_index :users, [:amocrm_id, :email, :emails, :phones]
  end
end
