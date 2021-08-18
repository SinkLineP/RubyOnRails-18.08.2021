# Контроллер раздела "Отзывы"
# @see app/views/admin/recalls
module Admin
  class RecallsController < AdminController
    load_and_authorize_resource

    before_action only: %i(edit update destroy) do
      force_update_current_shop_id(@recall.shop_id)
    end

    set_current_shop_for_model(Recall)
    set_current_shop_for_model(Course)

    before_action :store_path_history

    def index
      @recalls = Recall.ordered.paginate(page: params[:page] || 1, per_page: PER_PAGE)
    end

    def new; end

    def create
      if @recall.save
        redirect_to last_uri
      else
        render :new
      end
    end

    def edit; end

    def update
      @recall.assign_attributes(recall_params)
      if @recall.save
        redirect_to last_uri
      else
        render :edit
      end
    end

    def destroy
      @recall.destroy
      redirect_to last_uri
    end

    def list
      recalls = Recall.alphabetical_order

      if params[:term].present?
        recalls = recalls.where('message ilike ?', "%#{params[:term]}%")
      end

      render json: recalls.first(LIST_SIZE).map { |recall| {value: recall.message, id: recall.id} }
    end

    private

    def recall_params
      params.require(:recall).permit!.tap do |h|
        h[:course_ids] ||= []
      end
    end

  end
end