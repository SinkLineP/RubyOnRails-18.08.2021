class AddJobIdToAmocrmImport < ActiveRecord::Migration
  def change
    add_column :amocrm_imports, :job_id, :integer
  end
end
