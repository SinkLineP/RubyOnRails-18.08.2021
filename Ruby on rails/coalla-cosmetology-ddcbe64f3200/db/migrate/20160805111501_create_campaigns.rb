class CreateCampaigns < ActiveRecord::Migration
  def change
    create_table :campaigns do |t|
      t.text :co_magick_id, null: false
      t.text :name
      t.text :phone_type
      t.text :phone
      t.text :utm_sources, array: true, default: []
      t.text :utm_mediums, array: true, default: []
      t.text :utm_campaigns, array: true, default: []

      t.timestamps null: false
    end
  end
end
