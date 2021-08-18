class AddAmocrmTagToGroupSubscription < ActiveRecord::Migration
  def change
    add_column :group_subscriptions, :amocrm_tags, :text, array: true
  end
end
