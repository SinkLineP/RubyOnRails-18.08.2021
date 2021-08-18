# Контроллер раздела "Вопрос-ответ"
# @see app/views/admin/faq
module Admin
  class FaqController < AdminController
    load_and_authorize_resource

    before_action only: %i(edit update destroy) do
      force_update_current_shop_id(@faq.shop_id)
    end

    set_current_shop_for_model(Faq)

    def index
      @faq = Faq.ordered.paginate(page: params[:page] || 1, per_page: PER_PAGE)
    end

    def create
      save_and_responce
    end

    def update
      @faq.assign_attributes(faq_params)
      save_and_responce
    end

    def destroy
      @faq.destroy
      redirect_to admin_faq_index_path
    end

    protected

    def save_and_responce
      if @faq.save
        redirect_to admin_faq_index_path
        return
      end

      render :edit
    end

    def faq_params
      params.require(:faq).permit!
    end
  end
end