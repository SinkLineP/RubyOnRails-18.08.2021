class CreateCampaignIndices < ActiveRecord::Migration
  def change
    create_table :campaign_indices do |t|
      t.references :campaign, index: true, foreign_key: true
      t.string :name
      t.string :service
      t.float :value, null: false, default: 0
      t.date :created_on

      t.timestamps null: false
    end
  end
end
