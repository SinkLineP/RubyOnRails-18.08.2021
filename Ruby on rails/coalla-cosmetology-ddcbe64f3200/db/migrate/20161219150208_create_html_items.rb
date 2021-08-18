class CreateHtmlItems < ActiveRecord::Migration
  def change
    create_table :html_items do |t|
      t.string :page
      t.text :title
      t.text :description
      t.text :content

      t.timestamps null: false
    end
  end
end
