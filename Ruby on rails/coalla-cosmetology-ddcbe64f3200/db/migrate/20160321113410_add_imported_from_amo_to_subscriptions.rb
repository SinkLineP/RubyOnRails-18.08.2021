class AddImportedFromAmoToSubscriptions < ActiveRecord::Migration
  def change
    add_column :group_subscriptions, :imported_from_amo, :boolean, default: false, null: false
  end
end
