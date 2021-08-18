class RenameSaleStageId < ActiveRecord::Migration
  def change
    rename_column :group_subscriptions, :sale_stage_id, :amocrm_status_id
  end
end
