class AddSeopultIdToCampaign < ActiveRecord::Migration
  def up
    add_column :campaigns, :seopult_id, :string
  end

  def down
    remove_column :campaigns, :seopult_id
  end
end
