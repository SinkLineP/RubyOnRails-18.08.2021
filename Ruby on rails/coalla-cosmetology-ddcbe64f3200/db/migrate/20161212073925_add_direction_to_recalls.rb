class AddDirectionToRecalls < ActiveRecord::Migration
  def change
    add_column :recalls, :directions, :text
  end
end
