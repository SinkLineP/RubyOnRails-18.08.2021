class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.references :notable, polymorphic: true, index: true
      t.datetime :noted_at
      t.text :amocrm_id
      t.integer :note_type
      t.text :text

      t.timestamps null: false
    end
  end
end
