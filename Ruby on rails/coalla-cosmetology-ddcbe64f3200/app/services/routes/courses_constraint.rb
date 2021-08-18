# frozen_string_literal: true

module Routes
  class CoursesConstraint
    def self.matches?(request)
      current_shop = Shop.find_by_request_or_default(request)
      SharedModels.with_shop(current_shop.id) do
        speciality = Speciality.find_by_friendly(request.params[:speciality_id])
        return false if request.params[:speciality_id] != "courses" && !speciality
        Course.exists?(slug: request.params[:id])
      end
    end
  end
end
