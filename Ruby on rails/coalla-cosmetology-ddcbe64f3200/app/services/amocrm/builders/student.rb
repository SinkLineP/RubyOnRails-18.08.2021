module Amocrm
  module Builders
    class Student < Item
      def create_or_update!
        begin
          item = ::Student.find_or_initialize_by(amocrm_id: @amocrm_entity.id)

          check_data_actuality!(item)

          item.skip_sync_amo_data!

          assign_defaults(item) if item.new_record?
          assign_emails(item)
          assign_phones(item)
          assign_name(item)
          assign_specific_info(item)
          check_item_validity!(item)

          item.save!
        rescue PG::UniqueViolation
          unprocessable_data!('Possible duplicated request.')
        end

        update_subscriptions(item)
        check_item_validity!(item)

        [item]
      end

      private

      def assign_defaults(item)
        item.assign_attributes(imported_from_amo: true,
                               password: Devise.friendly_token(8),
                               source: :amocrm)
      end

      def assign_emails(item)
        emails = @amocrm_entity.emails
        item.email = emails.first || item.generated_email if item.email.blank?
        item.emails += (emails - (item.emails + [item.email]))
      end

      def assign_phones(item)
        phones = @amocrm_entity.phones
        new_phones = phones - item.phones
        item.phones += new_phones
      end

      def assign_name(item)
        names = @amocrm_entity.name.to_s.strip.squish.split("\s").map { |n| n.strip.squish }.join(' ')
        item.full_name = names
      end

      def assign_specific_info(item)
        education_level = EducationLevel.find_by(id: @amocrm_entity.education_level_id)
        item.assign_attributes(amo_created_at: parse_time(@amocrm_entity.date_create),
                               comagic_campaign: @amocrm_entity.comagic_campaign,
                               education_level: education_level)
      end

      def update_subscriptions(item)
        return if @amocrm_entity.linked_leads_id.blank?
        leads_ids = (@amocrm_entity.linked_leads_id.is_a?(Array) ? @amocrm_entity.linked_leads_id : @amocrm_entity.linked_leads_id.values.map { |data| data['ID'] }).reject(&:blank?)
        ::GroupSubscription.where(amocrm_id: leads_ids).each do |subscription|
          subscription.update(student_id: item.id)
        end
      end
    end
  end
end