class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.text :name
      t.timestamps
    end
    ['Новость института', 'Новость красоты'].each do |name|
      Category.create!(name: name)
    end
  end

  def down
    drop_table :categories
  end
end
