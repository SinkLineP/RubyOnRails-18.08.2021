class RenameErrors < ActiveRecord::Migration
  def change
    rename_column :amocrm_imports, :errors, :errors_string
  end
end
