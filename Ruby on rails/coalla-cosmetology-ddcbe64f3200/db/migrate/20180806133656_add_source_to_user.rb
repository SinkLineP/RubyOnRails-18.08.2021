class AddSourceToUser < ActiveRecord::Migration
  def up
    add_column :users, :source, :string, null: false, default: 'none'

    User.where(imported_from_amo: true).update_all(source: :amocrm)
    User.where(type: %w(Administrator Manager Instructor)).update_all(source: :dashboard)
  end

  def down
    remove_column :users, :source
  end
end
