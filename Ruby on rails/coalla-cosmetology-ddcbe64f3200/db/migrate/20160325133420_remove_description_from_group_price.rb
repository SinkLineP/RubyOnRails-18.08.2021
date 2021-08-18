class RemoveDescriptionFromGroupPrice < ActiveRecord::Migration
  def change
    remove_column :group_prices, :description, :text
  end
end
