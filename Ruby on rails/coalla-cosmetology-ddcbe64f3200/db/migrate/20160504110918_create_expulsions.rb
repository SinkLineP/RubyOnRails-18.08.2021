class CreateExpulsions < ActiveRecord::Migration
  def change
    create_table :expulsions do |t|
      t.references :group, index: true, foreign_key: true
      t.boolean :personal, null: false, default: true
      t.boolean :non_attendance, null: false, default: true
      t.date :expelled_on

      t.timestamps null: false
    end
  end
end
