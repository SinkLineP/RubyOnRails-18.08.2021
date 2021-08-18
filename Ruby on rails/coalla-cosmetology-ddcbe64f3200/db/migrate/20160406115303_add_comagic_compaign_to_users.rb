class AddComagicCompaignToUsers < ActiveRecord::Migration
  def change
    add_column :users, :comagic_compaign, :text
  end
end
