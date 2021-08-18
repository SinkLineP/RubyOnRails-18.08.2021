class CreateLookups < ActiveRecord::Migration
  def change
    create_table(:lookups) do |t|
      t.text :code, null: false
      t.text :value
      t.text :type_code, null: false
      t.timestamps
    end

    add_index :lookups, :code, unique: true
    add_index :lookups, :type_code
  end
end