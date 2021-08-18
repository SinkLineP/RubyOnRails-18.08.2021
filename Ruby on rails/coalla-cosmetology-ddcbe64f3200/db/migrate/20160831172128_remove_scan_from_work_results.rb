class RemoveScanFromWorkResults < ActiveRecord::Migration
  def change
    remove_column :work_results, :scan, :text
  end
end
