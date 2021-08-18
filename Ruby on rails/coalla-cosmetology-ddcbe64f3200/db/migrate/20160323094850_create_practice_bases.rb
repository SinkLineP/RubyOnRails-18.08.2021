class CreatePracticeBases < ActiveRecord::Migration
  def change
    create_table :practice_bases do |t|
      t.text :title, null: false
      t.text :address
      t.integer :inn
      t.integer :kpp
      t.integer :account
      t.integer :bik
      t.text :bank
      t.integer :correspondent_account
      t.text :phone
      t.text :email
      t.text :medical_license

      t.timestamps null: false
    end
  end
end
