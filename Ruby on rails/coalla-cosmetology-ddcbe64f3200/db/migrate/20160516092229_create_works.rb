class CreateWorks < ActiveRecord::Migration
  def change
    create_table :works do |t|
      t.text :title
      t.text :appendix
      t.text :type
      t.text :form_sheet

      t.timestamps null: false
    end
  end
end
