class CreateSms < ActiveRecord::Migration
  def change
    create_table :sms do |t|
      t.text :number
      t.text :text
      t.integer :message_id
      t.text :status

      t.timestamps null: false
    end
  end
end
