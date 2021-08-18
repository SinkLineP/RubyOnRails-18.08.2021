# We need to have an ability to upload files which includes russian characters, so we
# have to extend upload carrierwave security rules (see code below). Because of ruby
# bug you can't upload such files in Windows OS
unless RUBY_PLATFORM.downcase.include?('win') || RUBY_PLATFORM.downcase.include?('mingw')

  CarrierWave::SanitizedFile.sanitize_regexp = /[^[:word:]\.\-\+]/

end

# for STI
module CarrierWave

  module Mount

    class Mounter

      def cache_name=(cache_name)
        unless uploader.cached?
          result = uploader.retrieve_from_cache!(cache_name)
          record.send("#{serialization_column}_will_change!")
          result
        end
      rescue CarrierWave::InvalidParameter
      end

    end

  end

end


# override presence validator
module Carrierwave
  module Validations
    class PresenceValidator < ActiveRecord::Validations::PresenceValidator # :nodoc:
      def validate_each(record, attr_name, value)
        record.errors.add(attr_name, :blank, options) if value.blank? || carrier_wave_image_present?(record, attr_name)
      end

      private

      def carrier_wave_image_present?(record, attr_name)
        (record.send(attr_name).try(:is_a?, CarrierWave::Uploader::Base) && record.try("remove_#{attr_name}?"))
      end
    end
  end
end

ActiveRecord::Base.instance_eval do
  def validates_presence_of(*attr_names)
    validates_with Carrierwave::Validations::PresenceValidator, _merge_attributes(attr_names)
  end
end