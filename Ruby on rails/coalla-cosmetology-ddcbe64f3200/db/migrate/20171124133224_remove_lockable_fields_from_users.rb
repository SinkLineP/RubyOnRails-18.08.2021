class RemoveLockableFieldsFromUsers < ActiveRecord::Migration
  def change
    remove_column :users,
                  :failed_attempts,
                  :integer,
                  default: 0,
                  null: false
    remove_column :users, :unlock_token, :string
    remove_column :users, :locked_at, :datetime
  end
end
