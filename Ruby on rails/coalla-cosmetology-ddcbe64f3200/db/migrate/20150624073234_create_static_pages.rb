class CreateStaticPages < ActiveRecord::Migration
  def change
    create_table :static_pages do |t|
      t.text :title, null: false
      t.text :content
      t.text :slug, null: false
      t.boolean :permanent, null: false, default: false
      t.timestamps
    end

    add_index :static_pages, :slug, unique: true

    StaticPage.create!(slug: :about, title: 'О ПРОЕКТЕ', permanent: true)
    StaticPage.create!(slug: :about_institute, title: 'ОБ ИНСТИТУТЕ', permanent: true)
  end
end
