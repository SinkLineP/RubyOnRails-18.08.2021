# frozen_string_literal: true

module Routes
  class SpecialitiesConstraint
    def self.matches?(request)
      current_shop = Shop.find_by_request_or_default(request)
      SharedModels.with_shop(current_shop.id) do
        if request.params[:root_id]
          root_speciality = Speciality.find_by(slug: request.params[:root_id])
          !OldUrl.where(url: request.path).exists? && root_speciality && root_speciality.children.exists?(slug: request.params[:id])
        else
          !OldUrl.where(url: request.path).exists? && Speciality.exists?(request.params[:id])
        end
      end
    end
  end
end
