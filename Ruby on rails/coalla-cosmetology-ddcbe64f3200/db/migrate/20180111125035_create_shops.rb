class CreateShops < ActiveRecord::Migration
  def change
    create_table :shops do |t|
      t.text :title, null: false
      t.text :subdomain, null: false
      t.timestamps null: false
    end
  end
end
