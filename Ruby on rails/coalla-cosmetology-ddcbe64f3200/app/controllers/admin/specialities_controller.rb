# Контроллер раздела "Направления"
# @see app/views/admin/specialities/
module Admin
  class SpecialitiesController < ResourceController
    set_current_shop_for_model(Speciality)

    before_action only: [:edit, :update, :destroy] do
      scope = params[:root_id].present? ? resource_class.find_by_friendly!(params[:root_id]).children : resource_class.all
      self.resource = scope.find_by_friendly!(params[:id])
    end

    def index
      @specialities = Speciality.root.ordered
    end

    def list
      specialities = Speciality.sub_specialities.alphabetical_order

      if params[:term].present?
        specialities = specialities.where('title ilike ?', "%#{params[:term]}%")
      end

      render json: specialities.first(LIST_SIZE).map { |speciality| {value: speciality.full_title, id: speciality.id} }
    end
  end
end