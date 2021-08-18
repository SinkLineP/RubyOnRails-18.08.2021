class AddNotifiedToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :notified, :boolean, null: false, default: false
  end
end
