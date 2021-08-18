class AddFieldsToUser < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.text :middle_name
      t.date :birthday
      t.text :translit_name
      t.text :phones, array: true, default: []
      t.text :emails, array: true, default: []

      t.references :education_level, index: true, foreign_key: true

      t.text :passport_series
      t.text :passport_number
      t.date :passport_issued_on
      t.text :passport_organisation
      t.text :passport_address
      t.text :address

      t.text :amocrm_id
      t.text :amocrm_url

      t.references :ad_channel, index: true, foreign_key: true
    end
  end
end
