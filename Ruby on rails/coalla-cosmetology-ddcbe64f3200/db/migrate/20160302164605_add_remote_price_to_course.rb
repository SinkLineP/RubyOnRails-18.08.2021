class AddRemotePriceToCourse < ActiveRecord::Migration
  def change
    add_column :courses, :remote_price, :integer, null: false, default: 0
  end
end
