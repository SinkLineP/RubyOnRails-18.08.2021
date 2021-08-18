class AddFakeToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :fake, :boolean, default: false
  end
end

