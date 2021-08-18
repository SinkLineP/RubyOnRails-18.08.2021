class AddImageToColumnsVariants < ActiveRecord::Migration
  def change
    add_column :column_variants, :image, :text
  end
end
