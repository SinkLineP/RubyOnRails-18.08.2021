class AddImpressionsCountToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :impressions_count, :integer, default: 0, null: false
  end
end
