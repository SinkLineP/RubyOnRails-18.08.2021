class RenameDaysToTime < ActiveRecord::Migration
  def change
    rename_column :lectures, :days, :time
  end
end
