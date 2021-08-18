class CreateAdChannels < ActiveRecord::Migration
  def change
    create_table :ad_channels do |t|
      t.text :identifier
      t.text :title
      t.text :description
      t.text :utm_source
      t.text :utm_medium
      t.text :utm_campaign
      t.text :number_type
      t.text :phone_number

      t.timestamps null: false
    end
  end
end
