class AddPdfToMaterial < ActiveRecord::Migration
  def change
    add_column :materials, :pdf, :text
  end
end
