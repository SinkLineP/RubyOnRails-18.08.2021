module Amocrm
  module Entities
    class Contact < Amorail::Contact
      include ActualModificationTime

      amo_property :comagic_campaign
      amo_property :education_level_id
      amo_property :main

      def emails
        values_array(:email).map { |e| e.gsub("\s", '') }.map(&:downcase)
      end

      def phones
        values_array(:phone).map { |p| ::PhoneSanitizer.sanitize(p) }
      end

      private

      def values_array(field)
        value = self.send(field)
        (value.is_a?(Array) ? value : [value]).reject(&:blank?)
      end
    end
  end
end