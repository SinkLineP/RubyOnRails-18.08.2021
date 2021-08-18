# Контроллер раздела "Модули"
# @see app/views/admin/amo_modules
module Admin
  class AmoModulesController < AdminController
    authorize_resource

    before_action only: [:new, :create] do
      @amo_module = AmoModule.new(amo_module_params)
    end

    before_action only: [:edit, :update, :destroy] do
      @amo_module = AmoModule.find(params[:id])
    end

    def index
      @q = AmoModule.ransack(params[:q])
      @amo_modules = @q.result.ordered.paginate(page: params[:page] || 1, per_page: PER_PAGE)
    end

    def create
      apply_commit_action
    end

    def update
      @amo_module.assign_attributes(amo_module_params)
      apply_commit_action
    end

    def destroy
      @amo_module.destroy!
      redirect_to url_for(action: :index)
    end

    protected

    def save
      if @amo_module.save
        redirect_to edit_admin_amo_module_path(@amo_module)
      else
        render :edit
      end
    end

    def amo_module_params
      params[:amo_module] ? params.require(:amo_module).permit(:title, course_ids: []) : {}
    end

  end

end