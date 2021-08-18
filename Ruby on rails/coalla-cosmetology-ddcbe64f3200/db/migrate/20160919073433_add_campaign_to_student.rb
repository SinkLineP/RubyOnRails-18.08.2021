class AddCampaignToStudent < ActiveRecord::Migration
  def up
    add_reference :users, :campaign, foreign_key: true, index: true

    Student.find_each do |student|
      student.update_campaign
    end
  end

  def down
    remove_column :users, :campaign_id
  end
end
