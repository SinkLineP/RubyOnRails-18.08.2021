class CreateHistoryEvents < ActiveRecord::Migration
  def change
    create_table :history_events do |t|
      t.text :title
      t.text :year
      t.text :description
      t.text :image
      t.integer :position, null: false, default: 0
      t.timestamps
    end
  end
end
