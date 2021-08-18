# Контроллер раздела "Преимущества"
# @see app/views/admin/advantages
module Admin
  class AdvantagesController < AdminController
    load_and_authorize_resource

    def index
      @advantages = Advantage.order(created_at: :desc).paginate(page: params[:page] || 1, per_page: PER_PAGE)
    end

    def create
      save_and_responce
    end

    def update
      @advantage.assign_attributes(advantage_params)
      save_and_responce
    end

    def destroy
      @advantage.destroy
      redirect_to admin_advantages_path
    end

    def list
      advantages = Advantage.alphabetical_order

      if params[:term].present?
        advantages = advantages.where('title ilike ?', "%#{params[:term]}%")
      end

      render json: advantages.first(LIST_SIZE).map { |advantage| {value: advantage.title, id: advantage.id} }
    end

    private

    def advantage_params
      params.require(:advantage).permit!
    end

    def save_and_responce
      if @advantage.save
        redirect_to admin_advantages_path
        return
      end

      render :edit
    end

  end
end