module Amocrm
  module Entities
    module ActualModificationTime
      def actual_last_modified
        current_timestamp = Time.current.to_i
        if last_modified && last_modified >= current_timestamp
          # add 5 seconds to avoid 'outdated' error
          last_modified + 5
        else
          current_timestamp
        end
      end
    end
  end
end