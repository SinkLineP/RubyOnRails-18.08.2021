class AddContentFieldsToCourses < ActiveRecord::Migration
  def change
    change_table :courses do |t|
      t.string :slug
      t.string :title
      t.text :image
      t.text :announcement
      t.float :practice_hours, null: false, default: 0
      t.float :price_per_month, null: false, default: 0
      t.float :total_price, null: false, default: 0
      t.string :limitation
      t.text :video
      t.boolean :early_booking, null: false, default: false
      t.float :economy, null: false, default: 0
      t.string :job
      t.float :profit, null: false, default: 0
    end
  end
end
