class CreatePartners < ActiveRecord::Migration
  def change
    create_table :partners do |t|
      t.text :image, null: false
      t.text :title, null: false
      t.timestamps null: false
    end
  end
end
