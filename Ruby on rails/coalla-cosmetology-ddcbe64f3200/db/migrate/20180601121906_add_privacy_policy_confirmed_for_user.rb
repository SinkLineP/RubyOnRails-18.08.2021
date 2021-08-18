class AddPrivacyPolicyConfirmedForUser < ActiveRecord::Migration
  def change
    add_column :users, :privacy_policy_confirmed, :boolean, null: false, default: false
  end
end
