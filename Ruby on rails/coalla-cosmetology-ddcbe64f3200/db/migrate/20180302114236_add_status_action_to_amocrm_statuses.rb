class AddStatusActionToAmocrmStatuses < ActiveRecord::Migration
  def up
    add_column :amocrm_statuses, :status_action, :string

    AmocrmStatus.where(amocrm_id: [11990275, 18661504]).update_all(status_action: :meeting)
    AmocrmStatus.where(amocrm_id: [8391787, 11990269, 18661498]).update_all(status_action: :primary_treatment)
  end

  def down
    remove_column :amocrm_statuses, :status_action
  end
end
