# Контроллер раздела "Администраторы"
# @see app/views/admin/administrators
module Admin
  class AdministratorsController < AdminController
    load_and_authorize_resource

    def index
      @admins = Administrator.ordered.paginate(page: params[:page] || 1, per_page: PER_PAGE)
    end

    def new
      @administrator = Administrator.new
      render layout: false
    end

    def create
      @administrator.source = :dashboard
      if @administrator.save
        render json: { redirect_url: admin_administrators_path }
      else
        render json: { errors: @administrator.errors.full_messages.join("\n") }
      end
    end

    def edit
      render layout: false
    end

    def update
      @administrator.assign_attributes(administrator_params)
      if @administrator.save
        render json: { redirect_url: admin_administrators_path }
      else
        render json: { errors: @administrator.errors.full_messages.join("\n") }
      end
    end

    def destroy
      @administrator.destroy!
      redirect_to admin_administrators_path
    end

    private

    def administrator_params
      params.require(:user).permit!
    end
  end
end