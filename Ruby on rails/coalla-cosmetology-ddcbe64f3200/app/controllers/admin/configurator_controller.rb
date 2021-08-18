# Контроллер раздела "Конфигуратор"
# @see app/views/admin/campaigns
module Admin
  class ConfiguratorController < AdminController
    before_action do
      @configurator = Lookup.configurator
      authorize! :manage, @configurator
    end

    def edit; end

    def update
      @configurator.update(params.require(:lookup).permit!)
      redirect_to :edit_admin_configurator
    end
  end
end