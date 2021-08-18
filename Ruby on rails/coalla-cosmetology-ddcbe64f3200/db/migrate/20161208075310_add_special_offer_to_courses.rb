class AddSpecialOfferToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :special_offer, :boolean, null: false, default: false
  end
end
