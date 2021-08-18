class CreateAdvantages < ActiveRecord::Migration
  def change
    create_table :advantages do |t|
      t.text :title
      t.string :icon

      t.timestamps null: false
    end
  end
end
