class AddPdfToBook < ActiveRecord::Migration
  def change
    add_column :books, :pdf, :text
    add_column :books, :pdf_status, :text
    add_column :books, :type, :text

    Book.update_all(type: 'ScribdBook')
  end
end
