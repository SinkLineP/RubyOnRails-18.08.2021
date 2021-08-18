class AddAmoCreatedAtToUser < ActiveRecord::Migration
  def change
    add_column :users, :amo_created_at, :datetime
  end
end