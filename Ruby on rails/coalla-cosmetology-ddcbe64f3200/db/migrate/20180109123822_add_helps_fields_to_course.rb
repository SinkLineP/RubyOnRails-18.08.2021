class AddHelpsFieldsToCourse < ActiveRecord::Migration

  def change
    add_column :courses,:status_notification_name, :text, null: false, default: 'other_notification'
    add_column :courses,:place_over_notification, :boolean, null: false, default: false
    add_column :courses,:with_amo_module, :boolean, null: false, default: false

    Course.where(short_name: %w(СКДИ КДИ ДДИ МДИ SKDI-144 SKDI-288 KDI-144 KDI-576 DDI-144 DDI-576 MDI-144 MDI-288)).update_all(status_notification_name: 'skdi_notification')
    Course.where(short_name: %w(СК Э SK K)).update_all(status_notification_name: 'sk_notification')
    Course.where(short_name: %w(КЭ КЭВ KO KOV)).update_all(status_notification_name: 'ke_notification')
    Course.where(short_name: %w(КС КВ KC KV)).update_all(status_notification_name: 'ks_notification')
    Course.where(short_name: %w(КЭ Э СК КВ КС КЭВ ММ СПА-М KO K SK KV KC KOV MM SPA-M)).update_all(place_over_notification: true)
    Course.where(short_name: %w(КЭ KO КЭВ KOV Э K СК SK КС KC КВ KV)).update_all(with_amo_module: true)
  end

  def down
    remove_column :courses,:status_notification_name
    remove_column :courses,:place_over_notification
    remove_column :courses,:with_amo_module
  end
end
