class AddSuccessOn < ActiveRecord::Migration
  def change
    add_column :group_subscriptions, :sale_success_on, :datetime
  end
end
