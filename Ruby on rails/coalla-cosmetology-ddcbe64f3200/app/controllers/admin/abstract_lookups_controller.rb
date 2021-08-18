# Базовый контроллер
# для редактирования текстов об институте
# @see app/views/admin/abstract_lookups
module Admin
  class AbstractLookupsController < AdminController

    before_action only: %i(edit update) do
      @lookup = Lookup.send(scope_name).find(params[:id])
      force_update_current_shop_id(@lookup.shop_id)
    end

    set_current_shop_for_model(Lookup)

    helper_method :scope_name

    def index
      @lookups = Lookup.send(scope_name).order(:created_at).paginate(page: params[:page] || 1, per_page: PER_PAGE)
    end

    def update
      @lookup.update(lookup_params)
      render :edit
    end

    protected

    def scope_name
    end

    def lookup_params
      params.require(:lookup).permit!
    end

  end
end