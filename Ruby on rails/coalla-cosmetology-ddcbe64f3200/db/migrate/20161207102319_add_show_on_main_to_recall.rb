class AddShowOnMainToRecall < ActiveRecord::Migration
  def change
    add_column :recalls, :show_on_main, :boolean, default: false, null: false
  end
end
