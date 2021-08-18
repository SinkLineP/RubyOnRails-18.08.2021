# Базовый контроллер для управления сущностями
module Admin
  class ResourceController < AdminController
    authorize_resource

    before_action only: [:new, :create] do
      if resource_params[:type].present?
        self.resource = resource_params[:type].camelize.constantize.new
      else
        self.resource = resource_class.new
      end
    end

    before_action only: [:edit, :update, :destroy] do
      self.resource = resource_class.find(params[:id])
    end

    def index
      instance_variable_set("@#{controller_name}", resource_class.ordered.paginate(page: params[:page] || 1, per_page: per_page))
    end

    def new
      render layout: false
    end

    def create
      resource.assign_attributes(resource_params)
      save_and_response
    end

    def edit
      render layout: false
    end

    def update
      resource.assign_attributes(resource_params)
      save_and_response
    end

    def destroy
      resource.destroy
      redirect_to url_for(action: :index)
    end

    protected

    def save_and_response
      if resource.save
        render json: {redirect_url: url_for(action: :index)}
      else
        render json: {errors: resource.errors}
      end
    end

    def resource_params
      params[resource_name_underscore].present? ? params.require(resource_name_underscore).permit! : {}
    end

    def resource
      instance_variable_get("@#{resource_name_underscore}")
    end

    def resource=(value)
      instance_variable_set("@#{resource_name_underscore}", value)
    end

    def resource_name_underscore
      controller_name.singularize
    end

    def resource_class
      resource_name_underscore.camelize.constantize
    end

    def per_page
      PER_PAGE
    end
  end
end