# Генерация результатов занятий для группы
# @see app/assets/javascripts/admin/work_results.js.coffee
module Admin
  class StudentWorkResultsController < AdminController
    before_action do
      authorize! :manage, WorkResult
    end

    def create
      @work_result = WorkResult.new(params.require(:work_result).permit(:work_id, :group_id))
      @work_result.build_student_work_results
      work_result_exist = @work_result.work && @work_result.group ? WorkResult.where(work_id: @work_result.work_id, group_id: @work_result.group_id).any? : false
      render json: work_result_exist ? { error: 'Результат занятия для данной группы и занятия уже существует' } :
        { html: render_to_string(partial: 'admin/work_results/student_work_results') }
    end
  end
end