module Amocrm
  module Entities
    class Lead < Amorail::Lead
      include ActualModificationTime

      amo_property :group_id
      amo_property :education_form_id
      amo_property :group_price_id
      amo_property :discount_id
      amo_property :amo_module_id
      amo_property :removed_from_sdo
      amo_property :roistat
      amo_property :roistat_old
      amo_property :roistat_marker
      amo_property :promotion_source
      amo_property :promotion_id
      amo_field :pipeline_id
      amo_field :old_status_id

      def tags_list
        return tags.map { |data| data['name'] } if tags.present? && tags.is_a?(Array)
        return tags.values.map { |data| data['name'] } if tags.present? && tags.is_a?(Hash)
        fail NotPersisted if id.nil?
        @tags_list ||=
          begin
            lead = Lead.find(id)
            lead ? lead.tags.map { |data| data['name'] } : []
          end
      end

      def contact
        contacts.detect { |c| c.main == '1' } || contacts.first
      end

      def contacts
        fail NotPersisted if id.nil?
        @contacts ||=
          begin
            links = Amorail::ContactLink.find_by_leads(id)
            links.empty? ? [] : Contact.find_all(links.map(&:contact_id))
          end
      end
    end
  end
end