module Amocrm
  module Builders
    class Note < Item
      def initialize(amocrm_entity, notable_class)
        @amocrm_entity = amocrm_entity
        @notable_class = notable_class
      end

      def create_or_update!
        notable = @notable_class.find_by(amocrm_id: @amocrm_entity.element_id)
        return if notable.blank?
        item = ::Note.find_or_initialize_by(amocrm_id: @amocrm_entity.id)
        item.assign_attributes(text: @amocrm_entity.text,
                                  note_type: @amocrm_entity.note_type,
                                  noted_at: noted_at,
                                  notable: notable)
        item.save!
        [item]
      end

      private

      def noted_at
        date_create = @amocrm_entity.date_create
        if date_create.present? && date_create.is_a?(Numeric)
          parse_time(@amocrm_entity.date_create)
        else
          date_create
        end
      end
    end
  end
end