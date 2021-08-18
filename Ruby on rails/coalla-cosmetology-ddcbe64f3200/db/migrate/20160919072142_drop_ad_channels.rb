class DropAdChannels < ActiveRecord::Migration
  def change
    remove_column :users, :ad_channel_id
    drop_table :ad_channels
  end
end
