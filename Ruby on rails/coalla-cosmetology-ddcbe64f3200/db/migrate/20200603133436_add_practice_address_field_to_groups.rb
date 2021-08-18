class AddPracticeAddressFieldToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :practice_address, :string
  end
end
