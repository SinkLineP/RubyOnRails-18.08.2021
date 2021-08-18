module GroupPlacesExtensions
  extend ActiveSupport::Concern

  included do
    %i(academics distances).each do |name|
      define_method("#{name}_free_place") do
        [send("#{name}_place") - send("#{name}_count"), 0].max
      end
    end

    def free_places_for(education_form)
      return unless education_form
      education_form.online? ? distances_free_place : academics_free_place
    end

    def free_places
      places = [academics_free_place, distances_free_place].select{|places| places > 0}
      places.min.to_i
    end
  end
end