class AddPdfStatusToEntities < ActiveRecord::Migration
  def change
    add_column :materials, :pdf_status, :text
    add_column :lectures, :pdf_status, :text
  end
end
