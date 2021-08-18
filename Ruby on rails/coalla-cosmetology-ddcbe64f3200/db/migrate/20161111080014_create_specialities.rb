class CreateSpecialities < ActiveRecord::Migration
  def change
    create_table :specialities do |t|
      t.text :title
      t.text :description
      t.references :parent, index: true
      t.foreign_key :specialities, column: :parent_id

      t.timestamps null: false
    end
  end
end
