# Список группы
# @see app/views/admin/group_lists/
# @see app/views/admin/groups/_form.html.haml
module Admin
  class GroupListsController < AdminController
    load_and_authorize_resource :group

    def show; end

    def update
      @group.save_and_generate_group_lists!
      redirect_to admin_group_group_list_path(@group)
    end

    protected

    def group_params
      params.require(:group).permit!
    end
  end
end