class CreateSimilarArticles < ActiveRecord::Migration
  def change
    create_table :similar_articles do |t|
      t.references :similar, index: true
      t.foreign_key :articles, column: :similar_id
      t.references :article, index: true, foreign_key: true
      t.integer :position, null: false, default: 0, index: true

      t.timestamps null: false
    end
  end
end
