class CreateGeneratedDocuments < ActiveRecord::Migration
  def change
    create_table :generated_documents do |t|
      t.text :path
      t.text :type
      t.text :file_name
      t.float :file_size
      t.integer :idx, index: true
      t.text :number
      t.integer :year
      t.date :created_on
      t.references :item, index: true, polymorphic: true
      t.text :user_file

      t.timestamps null: false
    end
  end
end
