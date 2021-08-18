# == Schema Information
#
# Table name: module_groups
#
#  id                    :integer          not null, primary key
#  amo_module_id         :integer
#  course_id             :integer
#  group_id              :integer
#  group_subscription_id :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#
# Indexes
#
#  index_module_groups_on_amo_module_id          (amo_module_id)
#  index_module_groups_on_course_id              (course_id)
#  index_module_groups_on_group_id               (group_id)
#  index_module_groups_on_group_subscription_id  (group_subscription_id)
#

class ModuleGroup < ActiveRecord::Base
  belongs_to :amo_module, inverse_of: :module_groups
  belongs_to :course, inverse_of: :module_groups
  belongs_to :group, inverse_of: :module_groups
  belongs_to :group_subscription, inverse_of: :module_groups
  has_one :module_subscription,
          class_name: 'GroupSubscription',
          inverse_of: :module_group,
          dependent: :nullify

  after_destroy :update_subscription_status

  def update_subscription_status
    return unless module_subscription
    module_subscription.update_columns(amocrm_status_id: AmocrmPipeline.modules_primary_treatment_status.id)
    GroupSubscriptions::AmoLeadActionJob.enqueue(:update, subscription_id: module_subscription.id)
  end

end
