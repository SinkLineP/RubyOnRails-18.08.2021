module Amocrm
  module Builders
    class Item
      def initialize(amocrm_entity)
        @amocrm_entity = amocrm_entity
        unprocessable_data!('Entity without ID') unless @amocrm_entity.id
      end

      protected

      def check_data_actuality!(item)
        return unless data_outdated?(item)

        unprocessable_data!("Data is outdated for #{item.class.name}##{item.id}.")
      end

      def check_item_validity!(item)
        return if item.valid?
        errors_list = item.errors.full_messages.join(',')
        unprocessable_data!("#{item.class.name}##{item.id || 'new'} has errors. #{errors_list}")
      end

      def data_outdated?(item)
        item.persisted? && parse_time(@amocrm_entity.last_modified) < item.updated_at
      end

      def unprocessable_data!(message)
        raise UnprocessableDataException.new("Couldn't create or update record. #{message}")
      end

      def parse_time(value)
        DateTime.strptime(value.to_s, '%s')
      end
    end
  end
end