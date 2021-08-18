# Контроллер раздела "Результаты занятий"
# @see app/views/admin/work_results
module Admin
  class WorkResultsController < AdminController
    load_and_authorize_resource

    def index
      scope = current_user.instructor? ? current_user.work_results : WorkResult
      @q = scope.includes(:student_work_results).order(created_at: :desc).ransack(params[:q])
      @work_results = @q.result.distinct.paginate(page: params[:page] || 1, per_page: PER_PAGE)
    end

    def new
      @work_result = WorkResult.new
    end

    def create
      @work_result = WorkResult.new(work_result_params)
      save_and_responce
    end

    def edit; end

    def update
      @work_result.assign_attributes(work_result_params)
      save_and_responce
    end

    def destroy
      @work_result.destroy
      redirect_to admin_work_results_path
    end

    protected

    def save_and_responce
      if @work_result.save
        redirect_to edit_admin_work_result_path(@work_result)
        return
      end

      render :edit
    end

    def work_result_params
      params.require(:work_result).permit!
    end
  end
end