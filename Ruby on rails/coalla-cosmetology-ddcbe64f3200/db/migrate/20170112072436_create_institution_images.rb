class CreateInstitutionImages < ActiveRecord::Migration
  def change
    create_table :institution_images do |t|
      t.text :image
      t.text :name
      t.references :institution_block, index: true, foreign_key: true
      t.integer :position, null: false, default: 0
      t.timestamps
    end
  end
end
