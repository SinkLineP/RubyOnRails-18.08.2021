class AddDeltaFromModels < ActiveRecord::Migration
  def change
    add_column :users, :delta, :boolean, null: false, default: true
    add_column :posts, :delta, :boolean, null: false, default: true
    add_column :books, :delta, :boolean, null: false, default: true
    add_column :blocks, :delta, :boolean, null: false, default: true
    add_column :courses, :delta, :boolean, null: false, default: true
  end
end
