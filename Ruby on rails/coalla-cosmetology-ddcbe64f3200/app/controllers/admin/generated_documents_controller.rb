# Скачивание выпускных документов и пустой ведомости
# @see app/views/admin/addition_orders/show.haml
# @see app/views/admin/attendance_logs/show.haml
# @see app/views/admin/expulsion_orders/show.haml
# @see app/views/admin/final_work_registries/show.haml
# @see app/views/admin/group_lists/show.haml
# @see app/views/admin/order_contracts/show.haml
# @see app/views/admin/orders/_form.html.haml
# @see app/views/admin/subscription_contracts/show.haml
# @see app/views/admin/work_results/_form.haml
# @see app/views/courses_shop/user_courses/_subscription.haml
# @see app/views/profiles/edit.haml
module Admin
  class GeneratedDocumentsController < AdminController
    load_and_authorize_resource
    skip_load_and_authorize_resource only: :download_empty_sheet

    def download
      send_file @generated_document.path
    end

    def download_empty_sheet
      work_result = WorkResult.find(params[:work_result_id])
      empty_document = work_result.build_generated_document(type: "#{work_result.work.type}Sheet")
      empty_document.generate(without_marks: true, student_work_results: work_result.actual_student_work_results)
      send_file empty_document.path
    end
  end
end