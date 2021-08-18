module Amocrm
  module Operations
    class UpdateGroupsInfo

      def perform
        Group.preload(:subscriptions).find_each do |group|
          group.subscriptions.each do |subscription|
            next if subscription.try(:amocrm_id).blank?
            lead = Amocrm::Entities::Lead.find(subscription.amocrm_id)
            next unless lead
            lead.update!(name: subscription.group_title, last_modified: lead.actual_last_modified)
          end
        end
      end
    end
  end
end