class RenameComagicField < ActiveRecord::Migration
  def change
    rename_column :users, :comagic_compaign, :comagic_campaign
  end
end
