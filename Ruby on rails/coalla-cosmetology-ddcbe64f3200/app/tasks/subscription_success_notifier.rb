class SubscriptionSuccessNotifier
  def self.run
    date = Time.current - 1.day
    GroupSubscription.where(sale_success_on: date.beginning_of_day..date.end_of_day).each do |subscription|
      begin
        lead = Amocrm::Entities::Lead.find(subscription.amocrm_id)

        if lead && lead.status_id.to_i == AmocrmStatus::SUCCESS && AmocrmPipeline.resuscitation.exclude?(lead.pipeline_id.to_i)
          tags = {'SKDI' => 'skdi', 'DDI' => 'ddi', 'MDI' => 'mdi',
                  'SK' => 'sk', 'KOV' => 'k', 'KO' => 'k',
                  'KC' => 'kv', 'KV' => 'kv', 'Bio' => 'kp',
                  'Kp-gub' => 'kn', 'KP' => 'kp', 'PRP' => 'kp',
                  'KN' => 'kn', 'Pereorbit' => 'pereorbit',
                  'COG' => 'cog', 'IK' => 'ik', 'MEZO' => 'ik',
                  'BTA' => 'ik', 'MN' => 'ik', 'SCLERO' => 'ik',
                  'KDI' => 'kdi', 'K' => 'k'}
          course_name = subscription.course.short_name.downcase
          tag = tags.detect { |key, value| course_name.include?(key.downcase) }
          tag = tag ? tag[1] : 'other'
          NotificationMailer.subscription_success_notification(subscription, tag).deliver
        end
      rescue => ex
        CustomExceptionNotifier.notify_exception(ex)
      end
    end
  end
end