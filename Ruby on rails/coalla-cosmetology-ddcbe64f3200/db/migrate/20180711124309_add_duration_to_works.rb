class AddDurationToWorks < ActiveRecord::Migration
  def change
    add_column :works, :duration, :integer,null: false, default: 0
  end
end
