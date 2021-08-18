class AddPdfToLecture < ActiveRecord::Migration
  def change
    add_column :lectures, :pdf, :text
  end
end
