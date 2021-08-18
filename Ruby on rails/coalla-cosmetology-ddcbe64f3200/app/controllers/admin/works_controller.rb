# Контроллер раздела "Занятия"
# @see app/views/admin/works
module Admin
  class WorksController < AdminController
    load_and_authorize_resource

    def index
      @works = Work.order(:title).paginate(page: params[:page] || 1, per_page: PER_PAGE)
    end

    def new
      @work = Exam.new(form_sheet: :f_3_7)
    end

    def create
      @work = Work.new(work_params)
      save_and_responce
    end

    def edit
    end

    def update
      @work.assign_attributes(work_params)
      save_and_responce
    end

    def destroy
      @work.destroy
      redirect_to admin_works_path
    end

    protected

    def save_and_responce
      if @work.save
        redirect_to edit_admin_work_path(@work)
        return
      end

      render :edit
    end

    def work_params
      params.require(:work).permit!
    end
  end
end