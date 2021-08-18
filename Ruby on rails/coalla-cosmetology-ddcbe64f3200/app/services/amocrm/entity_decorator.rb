module Amocrm
  module EntityDecorator
    extend ActiveSupport::Concern

    included do
      ENTITIES_LIMIT = 100_000
      ROWS_LIMIT = 500

      def self.find(id)
        return if id.blank?
        new.load_record(id)
      end

      def self.each(params={})
        params = params.merge(limit_rows: ROWS_LIMIT)

        datetime = params.delete(:datetime)
        params['if-modified-since'] = datetime.strftime('%a, %d %b %Y %H:%M:%S') if datetime.present?

        0.upto(ENTITIES_LIMIT) do |offset|
          response = client.safe_request(
            :get,
            remote_url('list'),
            params.merge!(limit_offset: offset * ROWS_LIMIT)
          )

          entities = load_many(response)
          break if entities.blank?

          entities.each do |entity|
            yield(entity)
          end
        end
      end

      protected

      def custom_fields
        props = properties.send(self.class.amo_name)

        custom_fields = []

        self.class.properties.each do |k, v|
          prop_id = props.send(k).id
          values = send(k)
          if values.is_a?(Array)
            prop_val = values.map { |value| { value: value }.merge(v) }
          else
            prop_val = [{ value: send(k) }.merge(v)]
          end
          custom_fields << { id: prop_id, values: prop_val }
        end

        custom_fields
      end

      private

      def merge_custom_fields(fields)
        return if fields.nil?

        # TODO: rework
        fields = fields.values.reject { |f| f['name'] == 'Тип сделки' } if fields.is_a?(Hash)
        fields.each do |f|
          fname = f['code'] || f['name']
          next if fname.nil?
          fname = "#{fname.downcase}="

          values = f.fetch('values')
          values = values.values if values.is_a?(Hash)

          if values.length <= 1
            value_first = values.first
            fval = value_first.is_a?(Hash) ? value_first['value'] : value_first
          else
            fval = values.map { |obj| obj['value'] if obj }
          end

          send(fname, fval) if respond_to?(fname)
        end
      end

      def handle_response(response, method)
        return false unless response.status == 200
        extract_method = "extract_data_#{method}"

        data = response.body['response'][self.class.amo_response_name]
        return false if data.is_a?(Hash) && data[method] && data[method].is_a?(Hash) && data[method]['errors'].present?

        reload_model(
          send(extract_method,
               response.body['response'][self.class.amo_response_name]
          )
        ) if respond_to?(extract_method, true)
        self
      end
    end
  end
end