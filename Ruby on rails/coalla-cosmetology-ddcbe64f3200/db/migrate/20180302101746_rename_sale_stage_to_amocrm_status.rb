class RenameSaleStageToAmocrmStatus < ActiveRecord::Migration
  def change
    rename_table :sale_stages, :amocrm_statuses
  end
end
