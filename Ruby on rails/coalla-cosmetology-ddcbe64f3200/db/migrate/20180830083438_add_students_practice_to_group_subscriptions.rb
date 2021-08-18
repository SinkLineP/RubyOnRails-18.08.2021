class AddStudentsPracticeToGroupSubscriptions < ActiveRecord::Migration
  def change
    add_column :group_subscriptions, :practice_entrance_agree, :boolean, null: false, default: false
    add_column :group_subscriptions, :practice_entrance_agree_at, :datetime

    add_column :group_subscriptions, :practice_entrance_disagree, :boolean, null: false, default: false
    add_column :group_subscriptions, :practice_entrance_disagree_at, :datetime

    add_column :group_subscriptions, :practice_date, :datetime
    add_column :group_subscriptions, :practice_date_at, :datetime

    add_column :group_subscriptions, :amo_module_at, :datetime
  end
end
