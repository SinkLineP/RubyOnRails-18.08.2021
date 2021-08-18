class ChangeBlogSubscribers < ActiveRecord::Migration
  def change
    change_column :blog_subscribers, :email, :text, null: true
  end
end
