# Реестры выпускных документов группы
# @see app/views/admin/final_work_registries/
# @see app/views/admin/groups/_form.html.haml
module Admin
  class FinalWorkRegistriesController < AdminController
    load_and_authorize_resource :group

    def show; end

    def update
      @group.save_and_generate_registries!
      redirect_to admin_group_final_work_registry_path(@group)
    end

    protected

    def group_params
      params.require(:group).permit!
    end
  end
end