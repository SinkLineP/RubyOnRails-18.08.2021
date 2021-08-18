class RemoveCachedAmocrmUrl < ActiveRecord::Migration
  def change
    remove_column :group_subscriptions, :amocrm_url, :text
    remove_column :users, :amocrm_url, :text
  end
end
