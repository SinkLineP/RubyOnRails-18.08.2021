class CreateAdminMagazinePaymentTypes < ActiveRecord::Migration
  def change
    create_table :magazine_payment_types do |t|
      t.text :title, null: false

      t.timestamps null: false
    end
  end
end
