class CreateAmoModules < ActiveRecord::Migration
  def change
    create_table :amo_modules do |t|
      t.text :title, null: false
      t.timestamps null: false
    end
  end
end
