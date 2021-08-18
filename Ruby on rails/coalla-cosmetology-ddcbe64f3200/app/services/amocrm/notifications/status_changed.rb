module Amocrm
  module Notifications
    class StatusChanged

      def initialize(amocrm_entity)
        @amocrm_entity = amocrm_entity
      end

      def notify
        return false unless notify?
        CosmetologyMailer.send(notification_name, @amocrm_entity.contact.emails.first, shop).deliver!
        return true
      rescue => ex
        CustomExceptionNotifier.notify_exception(ex)
      end

      private

      def notify?
        return false if @amocrm_entity.price.to_f.zero?
        return false if @amocrm_entity.contact.blank? || !(@amocrm_entity.contact.emails.first.to_s =~ Devise.email_regexp)
        return false if @amocrm_entity.tags_list.blank?
        return false if GroupSubscription.find_by(amocrm_id: @amocrm_entity.id).try(:expired?)
        true
      end

      def notification_name
        course = ::Course.find_by(short_name: @amocrm_entity.tags_list)
        course.try(:status_notification_name) || ::Course.status_notification_name.default_value
      end

      def shop
        AmocrmPipeline.find_by(amocrm_id: @amocrm_entity.pipeline_id).try(:shop) || Shop.default_shop
      end
    end
  end
end