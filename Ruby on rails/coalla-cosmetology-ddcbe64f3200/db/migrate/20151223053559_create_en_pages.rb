class CreateEnPages < ActiveRecord::Migration
  def change
    create_table :en_pages do |t|
      t.text :title
      t.text :content

      t.timestamps null: false
    end

    EnPage.create!
  end
end
