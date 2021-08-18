# Контроллер раздела "Консультация"
# @see app/views/admin/students
module Admin
  class ConsultationsController < AdminController
    load_and_authorize_resource

    def index
      @q = Consultation.joins(:used_time, :course).ransack(params[:q])
      @consultations = @q.result.ordered.paginate(page: params[:page] || 1, per_page: PER_PAGE)
    end

    def create
      save_and_responce
    end

    def update
      @consultation.assign_attributes(consultation_params)
      save_and_responce
    end

    def destroy
      @consultation.destroy
      redirect_to request.referer || admin_consultations_path
    end

    private

    def consultation_params
      params.require(:consultation).permit(:name, :email, :phone, :comment, :course_id, used_time_attributes: [:date, :time])
    end

    def save_and_responce
      if @consultation.save
        redirect_to admin_consultations_path
        return
      end

      render :edit
    end
  end
end