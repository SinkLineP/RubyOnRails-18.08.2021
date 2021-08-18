class AddDescriptionToPartners < ActiveRecord::Migration
  def change
    add_column :partners, :description, :text
  end
end
