class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.text :file
      t.timestamps null: false
      t.index :file
    end
  end
end
