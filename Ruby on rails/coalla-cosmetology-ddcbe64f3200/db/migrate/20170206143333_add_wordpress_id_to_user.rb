class AddWordpressIdToUser < ActiveRecord::Migration
  def change
    add_column :users, :wordpress_id, :integer
  end
end
