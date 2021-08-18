class AddErrorsToAmocrmImport < ActiveRecord::Migration
  def change
    add_column :amocrm_imports, :errors, :text
  end
end
