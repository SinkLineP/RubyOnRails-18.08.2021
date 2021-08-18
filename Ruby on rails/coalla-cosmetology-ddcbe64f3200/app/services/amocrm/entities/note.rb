module Amocrm
  module Entities
    class Note < Amorail::Entity
      include ActualModificationTime

      amo_names 'notes'

      amo_field :element_id, :element_type, :note_type, :text, :date_create
    end
  end
end