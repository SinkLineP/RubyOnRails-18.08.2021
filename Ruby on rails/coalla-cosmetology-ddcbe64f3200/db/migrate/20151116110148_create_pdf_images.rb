class CreatePdfImages < ActiveRecord::Migration
  def change
    create_table :pdf_images do |t|
      t.references :imagable, polymorphic: true, index: true
      t.text :image
      t.integer :position, :integer, null: false, default: 0

      t.timestamps null: false
    end
  end
end
