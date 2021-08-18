class CreateBlogSquareBanner < ActiveRecord::Migration
  def change
    create_table :blog_square_banners do |t|
      t.references :article, index: true, foreign_key: true
      t.references :square_banner, index: true, foreign_key: true
      t.integer :position, null: false, default: 0
      t.timestamps
    end
  end
end
