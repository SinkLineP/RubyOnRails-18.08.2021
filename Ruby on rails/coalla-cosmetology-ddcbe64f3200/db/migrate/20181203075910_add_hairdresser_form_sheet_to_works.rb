class AddHairdresserFormSheetToWorks < ActiveRecord::Migration
  def change
    add_column :works, :hairdresser_form_sheet, :text
  end
end
