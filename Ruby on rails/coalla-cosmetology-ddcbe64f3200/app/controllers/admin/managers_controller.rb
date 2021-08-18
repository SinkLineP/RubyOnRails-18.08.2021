# Контроллер раздела "Менеджеры"
# @see app/views/admin/managers
module Admin
  class ManagersController < AdminController
    load_and_authorize_resource

    def index
      @managers = Manager.ordered.paginate(page: params[:page] || 1, per_page: PER_PAGE)
    end

    def new
      @manager = Manager.new
      render layout: false
    end

    def create
      if @manager.save
        render json: { redirect_url: admin_managers_path }
      else
        render json: { errors: @manager.errors.full_messages.join("\n") }
      end
    end

    def edit
      render layout: false
    end

    def update
      @manager.assign_attributes(manager_params)

      if @manager.save
        render json: { redirect_url: admin_managers_path }
      else
        render json: { errors: @manager.errors.full_messages.join("\n") }
      end
    end

    def destroy
      @manager.destroy!
      redirect_to admin_managers_path
    end

    private

    def manager_params
      params.require(:user).permit!
    end
  end
end