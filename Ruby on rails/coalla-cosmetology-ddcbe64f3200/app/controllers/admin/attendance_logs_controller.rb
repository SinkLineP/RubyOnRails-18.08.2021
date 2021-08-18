# Журналы посещаемости группы
# @see app/views/admin/attendance_logs
# @see app/views/admin/groups/_form.html.haml
module Admin
  class AttendanceLogsController < AdminController
    load_and_authorize_resource :group

    def show; end

    def update
      @group.assign_attributes(document_params) if params.has_key?(:group)
      @group.save_and_generate_attendances!
      redirect_to admin_group_attendance_log_path(@group)
    end

    protected

    def group_params
      params.require(:group).permit!
    end

    def document_params
      params.require(:group).permit(document_copies_attributes: [:id, :_destroy, :file_cache])
    end
  end
end