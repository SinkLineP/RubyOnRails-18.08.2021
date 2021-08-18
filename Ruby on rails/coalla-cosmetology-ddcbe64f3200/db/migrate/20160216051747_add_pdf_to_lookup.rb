class AddPdfToLookup < ActiveRecord::Migration
  def change
    add_column :lookups, :pdf, :text
    add_column :lookups, :pdf_status, :text
  end
end
