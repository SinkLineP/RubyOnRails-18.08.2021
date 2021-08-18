class AddPriceToCourse < ActiveRecord::Migration
  def change
    add_column :courses, :cost, :integer, default: 0
  end
end